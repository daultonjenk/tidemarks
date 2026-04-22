extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.08, 0.06, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var title := Label.new()
	title.text = "Merchant's Ledger"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_bottom = 50
	add_child(title)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.offset_top = 55
	scroll.offset_bottom = -60
	add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 8)
	scroll.add_child(vbox)

	var history := GameState.voyage_history
	if history.is_empty():
		var placeholder := Label.new()
		placeholder.text = "No voyages yet. Set sail!"
		placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		vbox.add_child(placeholder)
	else:
		for entry in history:
			vbox.add_child(_build_entry_row(entry))

	var back_btn := Button.new()
	back_btn.text = "< Back"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	back_btn.offset_top = -55
	back_btn.offset_right = 120
	back_btn.offset_bottom = -10
	back_btn.pressed.connect(_go_back)
	add_child(back_btn)


func _build_entry_row(entry: Dictionary) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var vbox := VBoxContainer.new()
	panel.add_child(vbox)

	var dest := Economy.get_port_by_id(entry.get("destination_port_id", ""))
	var dest_name := dest.get("name", entry.get("destination_port_id", "Unknown"))
	var ts: int = entry.get("timestamp", 0)
	var dt := Time.get_datetime_dict_from_unix_time(ts)
	var date_str := "%04d-%02d-%02d %02d:%02d" % [dt["year"], dt["month"], dt["day"], dt["hour"], dt["minute"]]

	var dest_lbl := Label.new()
	dest_lbl.text = "→ %s  (%s)" % [dest_name, date_str]
	vbox.add_child(dest_lbl)

	var event_lbl := Label.new()
	event_lbl.text = entry.get("event_description", "")
	event_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(event_lbl)

	return panel


func _go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
