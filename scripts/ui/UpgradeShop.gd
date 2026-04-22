extends Control

const UPGRADES := [
	{
		"id": "larger_hull",
		"label": "Larger Hull",
		"desc": "+10 cargo capacity",
		"cost": 300,
	},
	{
		"id": "faster_sails",
		"label": "Faster Sails",
		"desc": "25% shorter voyages",
		"cost": 500,
	},
	{
		"id": "first_mate",
		"label": "First Mate",
		"desc": "Unlocks second ship (V2)",
		"cost": 1500,
	},
]

var _gold_label: Label
var _upgrade_rows: Array = []


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.1, 0.08, 0.05, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 12)
	add_child(vbox)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 40)
	vbox.add_child(spacer)

	var title := Label.new()
	title.text = "Upgrades"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_gold_label = Label.new()
	_gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_gold_label)

	for upgrade in UPGRADES:
		var row := _build_upgrade_row(upgrade)
		vbox.add_child(row)
		_upgrade_rows.append({"upgrade": upgrade, "btn": row.get_child(row.get_child_count() - 1)})

	var back_btn := Button.new()
	back_btn.text = "< Back"
	back_btn.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	back_btn.offset_top = -55
	back_btn.offset_right = 120
	back_btn.offset_bottom = -10
	back_btn.pressed.connect(_go_back)
	add_child(back_btn)

	_refresh()


func _build_upgrade_row(upgrade: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)

	var info_col := VBoxContainer.new()
	info_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(info_col)

	var name_lbl := Label.new()
	name_lbl.text = upgrade["label"]
	info_col.add_child(name_lbl)

	var desc_lbl := Label.new()
	desc_lbl.text = upgrade["desc"]
	info_col.add_child(desc_lbl)

	var btn := Button.new()
	btn.text = "%dg" % upgrade["cost"]
	btn.custom_minimum_size = Vector2(80, 0)
	btn.pressed.connect(_on_upgrade_pressed.bind(upgrade["id"], upgrade["cost"]))
	row.add_child(btn)

	return row


func _refresh() -> void:
	_gold_label.text = "Gold: %d" % GameState.gold
	for entry in _upgrade_rows:
		var owned: bool = GameState.upgrades.get(entry["upgrade"]["id"], false)
		var affordable: bool = GameState.gold >= entry["upgrade"]["cost"]
		var btn: Button = entry["btn"]
		if owned:
			btn.text = "Owned"
			btn.disabled = true
		else:
			btn.text = "%dg" % entry["upgrade"]["cost"]
			btn.disabled = not affordable


func _on_upgrade_pressed(upgrade_id: String, cost: int) -> void:
	if GameState.purchase_upgrade(upgrade_id, cost):
		_refresh()


func _go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
