extends Node

var ports: Array = []
var goods: Array = []
var prices: Dictionary = {}
var forecasts: Dictionary = {}
var last_tick_hour: int = -1


func initialize_prices() -> void:
	_load_data()
	var hour := _current_hour()
	last_tick_hour = hour
	for port in ports:
		prices[port["id"]] = {}
		forecasts[port["id"]] = {}
		for good in goods:
			prices[port["id"]][good["id"]] = _calculate_price(good, port, hour)
			forecasts[port["id"]][good["id"]] = _calculate_price(good, port, hour + 1)


func _load_data() -> void:
	ports = _load_json("res://data/ports.json")
	goods = _load_json("res://data/goods.json")


func _load_json(path: String) -> Array:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Economy: Cannot open " + path)
		return []
	var text := file.get_as_text()
	file.close()
	var parsed := JSON.parse_string(text)
	if not parsed is Array:
		push_error("Economy: Invalid JSON in " + path)
		return []
	return parsed


func tick_prices() -> void:
	var hour := _current_hour()
	if hour == last_tick_hour:
		return
	last_tick_hour = hour
	for port in ports:
		for good in goods:
			prices[port["id"]][good["id"]] = _calculate_price(good, port, hour)
			forecasts[port["id"]][good["id"]] = _calculate_price(good, port, hour + 1)


func get_price(port_id: String, good_id: String) -> int:
	tick_prices()
	return prices.get(port_id, {}).get(good_id, 0)


func get_forecast(port_id: String, good_id: String) -> int:
	tick_prices()
	return forecasts.get(port_id, {}).get(good_id, 0)


func get_port_by_id(port_id: String) -> Dictionary:
	for port in ports:
		if port["id"] == port_id:
			return port
	return {}


func get_good_by_id(good_id: String) -> Dictionary:
	for good in goods:
		if good["id"] == good_id:
			return good
	return {}


func _calculate_price(good: Dictionary, port: Dictionary, hour: int) -> int:
	var base := float(good["base_price"])
	var home_port = good.get("home_port", null)
	var port_modifier := 1.0
	if home_port != null:
		if home_port == port["id"]:
			port_modifier = 0.6
		else:
			port_modifier = 1.4
	var seed_val: int = (good["id"].hash() ^ port["id"].hash() ^ hour) & 0x7FFFFFFF
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_val
	var variance := rng.randf_range(0.8, 1.2)
	return maxi(1, int(base * port_modifier * variance))


func _current_hour() -> int:
	return int(Time.get_unix_time_from_system()) / 3600
