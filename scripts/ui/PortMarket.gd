extends Control

var _port_label: Label
var _gold_label: Label
var _cargo_label: Label
var _goods_container: VBoxContainer
var _feedback_label: Label
var _buy_qty: Dictionary = {}


func _ready() -> void:
	_build_ui()
	_populate_goods()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.1, 0.16, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var scroll := ScrollContainer.new()
	scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scroll.offset_bottom = -60
	add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 8)
	scroll.add_child(vbox)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	vbox.add_child(header)

	_port_label = Label.new()
	_port_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(_port_label)

	_gold_label = Label.new()
	_gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	header.add_child(_gold_label)

	_cargo_label = Label.new()
	_cargo_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(_cargo_label)

	var col_header := HBoxContainer.new()
	vbox.add_child(col_header)
	for col_text in ["Good", "Now", "Next Hr", "Hold", "", ""]:
		var lbl := Label.new()
		lbl.text = col_text
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col_header.add_child(lbl)

	_goods_container = VBoxContainer.new()
	_goods_container.add_theme_constant_override("separation", 4)
	vbox.add_child(_goods_container)

	_feedback_label = Label.new()
	_feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_feedback_label)

	var back_btn := Button.new()
	back_btn.text = "< Back"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	back_btn.offset_top = -55
	back_btn.offset_right = 120
	back_btn.offset_bottom = -10
	back_btn.pressed.connect(_go_back)
	add_child(back_btn)


func _populate_goods() -> void:
	for child in _goods_container.get_children():
		child.queue_free()
	_buy_qty.clear()

	var port_id := GameState.current_port_id
	var port := Economy.get_port_by_id(port_id)
	_port_label.text = port.get("name", "Unknown")
	_refresh_header()

	for good in Economy.goods:
		var good_id: String = good["id"]
		var current_price := Economy.get_price(port_id, good_id)
		var forecast_price := Economy.get_forecast(port_id, good_id)
		var held: int = GameState.cargo.get(good_id, 0)

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 4)
		_goods_container.add_child(row)

		var name_lbl := Label.new()
		name_lbl.text = good["name"]
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(name_lbl)

		var price_lbl := Label.new()
		price_lbl.text = str(current_price) + "g"
		price_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		price_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(price_lbl)

		var forecast_lbl := Label.new()
		var arrow := "→"
		if forecast_price > current_price:
			arrow = "↑"
			forecast_lbl.add_theme_color_override("font_color", Color.GREEN)
		elif forecast_price < current_price:
			arrow = "↓"
			forecast_lbl.add_theme_color_override("font_color", Color.RED)
		forecast_lbl.text = "%s%d" % [arrow, forecast_price]
		forecast_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		forecast_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(forecast_lbl)

		var hold_lbl := Label.new()
		hold_lbl.text = str(held)
		hold_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hold_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(hold_lbl)

		var buy_btn := Button.new()
		buy_btn.text = "Buy"
		buy_btn.disabled = not GameState.has_space(1) or GameState.gold < current_price
		buy_btn.pressed.connect(_on_buy.bind(good_id))
		row.add_child(buy_btn)

		var sell_btn := Button.new()
		sell_btn.text = "Sell"
		sell_btn.disabled = held == 0
		sell_btn.pressed.connect(_on_sell.bind(good_id))
		row.add_child(sell_btn)


func _refresh_header() -> void:
	var port_id := GameState.current_port_id
	var port := Economy.get_port_by_id(port_id)
	_port_label.text = port.get("name", "Unknown")
	_gold_label.text = "Gold: %d" % GameState.gold
	_cargo_label.text = "Cargo: %d / %d" % [GameState.cargo_used(), GameState.cargo_capacity]


func _on_buy(good_id: String) -> void:
	var port_id := GameState.current_port_id
	var price := Economy.get_price(port_id, good_id)
	var discount_pct := VoyageManager.pending_discount
	var final_price := int(price * (1.0 - discount_pct / 100.0))

	if not GameState.has_space(1):
		_feedback_label.text = "No cargo space!"
		return
	if GameState.gold < final_price:
		_feedback_label.text = "Not enough gold!"
		return

	GameState.spend_gold(final_price)
	GameState.add_cargo(good_id, 1)
	if discount_pct > 0:
		VoyageManager.pending_discount = 0
		_feedback_label.text = "Bought with %d%% discount!" % discount_pct
	else:
		_feedback_label.text = ""

	_populate_goods()


func _on_sell(good_id: String) -> void:
	var held: int = GameState.cargo.get(good_id, 0)
	if held == 0:
		_feedback_label.text = "Nothing to sell!"
		return

	var port_id := GameState.current_port_id
	var price := Economy.get_price(port_id, good_id)
	var earnings := price * held
	GameState.remove_cargo(good_id, held)
	GameState.add_gold(earnings)
	_feedback_label.text = "Sold %d %s for %dg" % [held, good_id, earnings]

	_populate_goods()


func _go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
