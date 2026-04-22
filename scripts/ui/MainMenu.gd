extends Control

var _gold_label: Label
var _port_label: Label
var _status_label: Label
var _event_panel: PanelContainer
var _event_label: Label


func _ready() -> void:
	Economy.tick_prices()

	var just_arrived := VoyageManager.check_arrival()

	_build_ui()

	if just_arrived:
		var event := VoyageManager.get_last_resolved_event()
		if not event.is_empty():
			_show_event_panel(event)
			VoyageManager.clear_last_resolved_event()

	_refresh_labels()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.1, 0.2, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 16)
	add_child(vbox)

	var spacer_top := Control.new()
	spacer_top.custom_minimum_size = Vector2(0, 80)
	vbox.add_child(spacer_top)

	var title := Label.new()
	title.text = "TIDEMARKS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer)

	_gold_label = Label.new()
	_gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_gold_label)

	_port_label = Label.new()
	_port_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_port_label)

	_status_label = Label.new()
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_status_label)

	var spacer2 := Control.new()
	spacer2.custom_minimum_size = Vector2(0, 20)
	vbox.add_child(spacer2)

	var btn_market := Button.new()
	btn_market.text = "Market"
	btn_market.pressed.connect(_go_to_market)
	vbox.add_child(btn_market)

	var btn_map := Button.new()
	btn_map.text = "Chart a Course"
	btn_map.pressed.connect(_go_to_map)
	vbox.add_child(btn_map)

	var btn_upgrades := Button.new()
	btn_upgrades.text = "Upgrades"
	btn_upgrades.pressed.connect(_go_to_upgrades)
	vbox.add_child(btn_upgrades)

	var btn_ledger := Button.new()
	btn_ledger.text = "Merchant's Ledger"
	btn_ledger.pressed.connect(_go_to_ledger)
	vbox.add_child(btn_ledger)

	_event_panel = _build_event_panel()
	add_child(_event_panel)


func _build_event_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(300, 200)
	panel.visible = false

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 12)
	panel.add_child(inner)

	var header := Label.new()
	header.text = "Voyage Report"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inner.add_child(header)

	_event_label = Label.new()
	_event_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_event_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	inner.add_child(_event_label)

	var btn := Button.new()
	btn.text = "Continue"
	btn.pressed.connect(func(): panel.visible = false)
	inner.add_child(btn)

	return panel


func _refresh_labels() -> void:
	_gold_label.text = "Gold: %d" % GameState.gold

	var port := Economy.get_port_by_id(GameState.current_port_id)
	_port_label.text = "Port: %s" % port.get("name", "Unknown")

	if VoyageManager.is_voyaging:
		var secs := VoyageManager.get_time_remaining()
		var dest := Economy.get_port_by_id(VoyageManager.destination_port_id)
		_status_label.text = "Ship en route to %s — %dm %ds remaining" % [
			dest.get("name", "?"),
			secs / 60,
			secs % 60,
		]
	else:
		_status_label.text = "Ship is docked."


func _show_event_panel(event: Dictionary) -> void:
	_event_label.text = event.get("description", "The voyage is complete.")
	_event_panel.visible = true


func _go_to_market() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/PortMarket.tscn")


func _go_to_map() -> void:
	if VoyageManager.is_voyaging:
		_status_label.text = "Ship is already at sea!"
		return
	get_tree().change_scene_to_file("res://scenes/world/WorldMap.tscn")


func _go_to_upgrades() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/UpgradeShop.tscn")


func _go_to_ledger() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/Ledger.tscn")
