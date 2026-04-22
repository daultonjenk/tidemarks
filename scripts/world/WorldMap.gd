extends Control

var _info_label: Label
var _confirm_panel: PanelContainer
var _confirm_label: Label
var _pending_port_id: String = ""

const MAP_REF_W := 500.0
const MAP_REF_H := 500.0


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var ocean := ColorRect.new()
	ocean.color = Color(0.08, 0.25, 0.45, 1.0)
	ocean.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(ocean)

	var title := Label.new()
	title.text = "Chart a Course"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_bottom = 40
	add_child(title)

	_info_label = Label.new()
	_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_info_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_info_label.offset_top = 40
	_info_label.offset_bottom = 80
	add_child(_info_label)

	_place_port_markers()

	var back_btn := Button.new()
	back_btn.text = "< Back"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	back_btn.offset_top = -55
	back_btn.offset_right = 120
	back_btn.offset_bottom = -10
	back_btn.pressed.connect(_go_back)
	add_child(back_btn)

	_confirm_panel = _build_confirm_panel()
	add_child(_confirm_panel)

	_refresh_info()


func _place_port_markers() -> void:
	for port in Economy.ports:
		var pos: Dictionary = port["position"]
		var btn := Button.new()
		btn.text = port["name"]
		btn.custom_minimum_size = Vector2(90, 36)

		var is_current := port["id"] == GameState.current_port_id
		var is_voyaging := VoyageManager.is_voyaging
		btn.disabled = is_current or is_voyaging

		btn.pressed.connect(_on_port_pressed.bind(port["id"], port["name"]))
		add_child(btn)

		await get_tree().process_frame
		var sx := pos["x"] / MAP_REF_W * size.x - btn.size.x / 2.0
		var sy := pos["y"] / MAP_REF_H * size.y - btn.size.y / 2.0
		btn.position = Vector2(clampf(sx, 0, size.x - btn.size.x), clampf(sy, 80, size.y - 60))


func _build_confirm_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(280, 160)
	panel.visible = false

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	_confirm_label = Label.new()
	_confirm_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_confirm_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_confirm_label)

	var btn_row := HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 12)
	vbox.add_child(btn_row)

	var cancel_btn := Button.new()
	cancel_btn.text = "Cancel"
	cancel_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cancel_btn.pressed.connect(func(): panel.visible = false)
	btn_row.add_child(cancel_btn)

	var confirm_btn := Button.new()
	confirm_btn.text = "Set Sail!"
	confirm_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confirm_btn.pressed.connect(_on_voyage_confirmed)
	btn_row.add_child(confirm_btn)

	return panel


func _refresh_info() -> void:
	var port := Economy.get_port_by_id(GameState.current_port_id)
	if VoyageManager.is_voyaging:
		var dest := Economy.get_port_by_id(VoyageManager.destination_port_id)
		var secs := VoyageManager.get_time_remaining()
		_info_label.text = "Voyaging to %s — %dm %ds remaining" % [
			dest.get("name", "?"), secs / 60, secs % 60
		]
	else:
		_info_label.text = "Currently at %s. Select a destination." % port.get("name", "?")


func _on_port_pressed(port_id: String, port_name: String) -> void:
	_pending_port_id = port_id
	_confirm_label.text = "Sail to %s?\n(~10 minutes)" % port_name
	_confirm_panel.visible = true


func _on_voyage_confirmed() -> void:
	_confirm_panel.visible = false
	if VoyageManager.start_voyage(_pending_port_id):
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
	else:
		_info_label.text = "Could not start voyage."


func _go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
