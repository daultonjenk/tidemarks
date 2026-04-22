extends Node

var is_voyaging: bool = false
var departure_time: int = 0
var arrival_time: int = 0
var destination_port_id: String = ""
var voyage_event: Dictionary = {}
var pending_discount: int = 0

const BASE_DURATION_MIN := 600
const BASE_DURATION_MAX := 900
const FASTER_SAILS_MULT := 0.75
const MIN_VOYAGE_SECONDS := 60

var _events: Array = []
var _last_resolved_event: Dictionary = {}


func _ready() -> void:
	_load_events()


func _load_events() -> void:
	var file := FileAccess.open("res://data/events.json", FileAccess.READ)
	if file == null:
		push_error("VoyageManager: Cannot open events.json")
		return
	var parsed := JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Array:
		_events = parsed


func start_voyage(destination_id: String) -> bool:
	if is_voyaging:
		return false
	departure_time = int(Time.get_unix_time_from_system())
	destination_port_id = destination_id
	voyage_event = _roll_event()

	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var duration := rng.randf_range(BASE_DURATION_MIN, BASE_DURATION_MAX)
	if GameState.upgrades.get("faster_sails", false):
		duration *= FASTER_SAILS_MULT

	var effect = voyage_event.get("effect", null)
	if effect != null and effect.has("travel_time_reduction_percent"):
		var reduction: float = effect["travel_time_reduction_percent"] / 100.0
		duration *= (1.0 - reduction)

	duration = maxf(duration, MIN_VOYAGE_SECONDS)
	arrival_time = departure_time + int(duration)
	is_voyaging = true
	SaveLoad.save_game()
	return true


func check_arrival() -> bool:
	if not is_voyaging:
		return false
	if int(Time.get_unix_time_from_system()) < arrival_time:
		return false
	_resolve_voyage()
	return true


func _resolve_voyage() -> void:
	is_voyaging = false
	_last_resolved_event = voyage_event.duplicate()
	GameState.current_port_id = destination_port_id

	var effect = voyage_event.get("effect", null)
	if effect != null:
		if effect.has("cargo_loss_percent"):
			_apply_cargo_loss(effect["cargo_loss_percent"])
		if effect.has("gold_loss_flat"):
			GameState.spend_gold(effect["gold_loss_flat"])
		if effect.has("bonus_good") and effect["bonus_good"] == "random":
			_grant_random_good(effect.get("bonus_qty", 1))
		if effect.has("discount_next_port_percent"):
			pending_discount = effect["discount_next_port_percent"]

	GameState.add_voyage_history_entry({
		"timestamp": arrival_time,
		"destination_port_id": destination_port_id,
		"event_id": voyage_event.get("id", "uneventful"),
		"event_description": voyage_event.get("description", ""),
	})

	voyage_event = {}
	SaveLoad.save_game()


func _apply_cargo_loss(percent: int) -> void:
	for good_id in GameState.cargo.keys().duplicate():
		var qty: int = GameState.cargo.get(good_id, 0)
		var loss := maxi(1, int(qty * percent / 100.0))
		GameState.remove_cargo(good_id, mini(loss, qty))


func _grant_random_good(qty: int) -> void:
	if Economy.goods.is_empty():
		return
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var good: Dictionary = Economy.goods[rng.randi() % Economy.goods.size()]
	GameState.add_cargo(good["id"], qty)


func _roll_event() -> Dictionary:
	var total := 0
	for ev in _events:
		total += int(ev["weight"])
	if total == 0:
		return {}
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var roll := rng.randi() % total
	var cumulative := 0
	for ev in _events:
		cumulative += int(ev["weight"])
		if roll < cumulative:
			return ev
	return _events[0]


func get_time_remaining() -> int:
	if not is_voyaging:
		return 0
	return maxi(0, arrival_time - int(Time.get_unix_time_from_system()))


func get_last_resolved_event() -> Dictionary:
	return _last_resolved_event


func clear_last_resolved_event() -> void:
	_last_resolved_event = {}


func get_save_data() -> Dictionary:
	return {
		"is_voyaging": is_voyaging,
		"departure_time": departure_time,
		"arrival_time": arrival_time,
		"destination_port_id": destination_port_id,
		"voyage_event": voyage_event.duplicate(),
		"pending_discount": pending_discount,
		"last_resolved_event": _last_resolved_event.duplicate(),
	}


func load_save_data(data: Dictionary) -> void:
	is_voyaging = data.get("is_voyaging", false)
	departure_time = data.get("departure_time", 0)
	arrival_time = data.get("arrival_time", 0)
	destination_port_id = data.get("destination_port_id", "")
	voyage_event = data.get("voyage_event", {})
	pending_discount = data.get("pending_discount", 0)
	_last_resolved_event = data.get("last_resolved_event", {})
