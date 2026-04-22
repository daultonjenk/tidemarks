extends Node

const SAVE_PATH := "user://tidemarks_save.json"


func save_game() -> void:
	var data := {
		"version": 1,
		"game_state": GameState.get_save_data(),
		"voyage_manager": VoyageManager.get_save_data(),
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveLoad: Cannot open save file for writing.")
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()


func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveLoad: Cannot open save file for reading.")
		return {}
	var content := file.get_as_text()
	file.close()
	var parsed := JSON.parse_string(content)
	if not parsed is Dictionary:
		push_error("SaveLoad: Save file contains invalid JSON.")
		return {}
	return parsed


func apply_save(data: Dictionary) -> void:
	if data.has("game_state"):
		GameState.load_save_data(data["game_state"])
	if data.has("voyage_manager"):
		VoyageManager.load_save_data(data["voyage_manager"])
