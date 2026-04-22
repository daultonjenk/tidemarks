extends Control

var _status_label: Label
var _eta_label: Label
var _destination_label: Label


func _ready() -> void:
	_build_ui()
	_refresh()


func _process(_delta: float) -> void:
	if VoyageManager.is_voyaging:
		_refresh()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.08, 0.15, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 16)
	add_child(vbox)

	var title := Label.new()
	title.text = "Voyage Status"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_destination_label = Label.new()
	_destination_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_destination_label)

	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_status_label)

	_eta_label = Label.new()
	_eta_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_eta_label)

	var back_btn := Button.new()
	back_btn.text = "< Back"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	back_btn.offset_top = -55
	back_btn.offset_right = 120
	back_btn.offset_bottom = -10
	back_btn.pressed.connect(_go_back)
	add_child(back_btn)


func _refresh() -> void:
	if not VoyageManager.is_voyaging:
		_status_label.text = "Ship is docked."
		_eta_label.text = ""
		_destination_label.text = ""
		return

	var secs := VoyageManager.get_time_remaining()
	var dest := Economy.get_port_by_id(VoyageManager.destination_port_id)
	_destination_label.text = "Destination: %s" % dest.get("name", "?")
	_status_label.text = "Voyage in progress..."
	_eta_label.text = "ETA: %d:%02d" % [secs / 60, secs % 60]


func _go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
