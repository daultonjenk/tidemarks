extends Node

signal gold_changed(new_value: int)
signal cargo_changed()

var gold: int = 500
var cargo: Dictionary = {}
var cargo_capacity: int = 10
var current_port_id: String = "port_haven"
var upgrades: Dictionary = {
	"larger_hull": false,
	"faster_sails": false,
	"first_mate": false,
}
var voyage_history: Array = []

func _ready() -> void:
	var data := SaveLoad.load_game()
	if not data.is_empty():
		SaveLoad.apply_save(data)
	Economy.initialize_prices()
	VoyageManager.check_arrival()


func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)
	SaveLoad.save_game()


func spend_gold(amount: int) -> bool:
	if gold < amount:
		return false
	gold -= amount
	gold_changed.emit(gold)
	SaveLoad.save_game()
	return true


func cargo_used() -> int:
	var total := 0
	for qty in cargo.values():
		total += qty
	return total


func has_space(quantity: int = 1) -> bool:
	return cargo_used() + quantity <= cargo_capacity


func add_cargo(good_id: String, quantity: int) -> bool:
	if not has_space(quantity):
		return false
	cargo[good_id] = cargo.get(good_id, 0) + quantity
	cargo_changed.emit()
	SaveLoad.save_game()
	return true


func remove_cargo(good_id: String, quantity: int) -> bool:
	if not cargo.has(good_id) or cargo[good_id] < quantity:
		return false
	cargo[good_id] -= quantity
	if cargo[good_id] == 0:
		cargo.erase(good_id)
	cargo_changed.emit()
	SaveLoad.save_game()
	return true


func purchase_upgrade(upgrade_id: String, cost: int) -> bool:
	if upgrades.get(upgrade_id, true):
		return false
	if not spend_gold(cost):
		return false
	upgrades[upgrade_id] = true
	_apply_upgrade(upgrade_id)
	SaveLoad.save_game()
	return true


func _apply_upgrade(upgrade_id: String) -> void:
	match upgrade_id:
		"larger_hull":
			cargo_capacity += 10


func add_voyage_history_entry(entry: Dictionary) -> void:
	voyage_history.push_front(entry)
	SaveLoad.save_game()


func get_save_data() -> Dictionary:
	return {
		"gold": gold,
		"cargo": cargo.duplicate(),
		"cargo_capacity": cargo_capacity,
		"current_port_id": current_port_id,
		"upgrades": upgrades.duplicate(),
		"voyage_history": voyage_history.duplicate(true),
	}


func load_save_data(data: Dictionary) -> void:
	gold = data.get("gold", 500)
	cargo = data.get("cargo", {})
	cargo_capacity = data.get("cargo_capacity", 10)
	current_port_id = data.get("current_port_id", "port_haven")
	upgrades = data.get("upgrades", upgrades.duplicate())
	voyage_history = data.get("voyage_history", [])
