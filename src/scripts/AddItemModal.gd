extends CenterContainer

onready var _close_btn = $PC/MC/VB/HB/CloseBtn
onready var _add_button = $PC/MC/VB/Button
onready var _labels_node = $PC/MC/VB/VB3/Labels
onready var _card_scene = preload("res://scenes/Card.tscn")

var _labels_chosen = []
var column_to_add_to = null

func _ready():
	_close_btn.connect("pressed", self, "_on_close_btn_pressed")
	_add_button.connect("pressed", self, "_on_add_button_pressed")

	connect("gui_input", self, "_on_gui_input")

	_init_labels()

func _init_labels():
	for node in _labels_node.get_children():
		node.set_clickable(true)
		node.connect("input_event", self, "_on_label_input_event")

func _on_label_input_event(node, event: InputEvent):

	if not event is InputEventMouseButton:
		return

	if event.pressed and event.button_index == BUTTON_LEFT:

		if node in _labels_chosen:
			_labels_chosen.erase(node)
		else:
			_labels_chosen.append(node)

		update_labels()

func update_labels():

	for label in _labels_node.get_children():
		var new_color = label.color

		if label in _labels_chosen:
			new_color = new_color.darkened(0.25)

		var new_stylebox = label.get_stylebox("panel").duplicate()
		new_stylebox.set_bg_color(new_color)
		label.add_stylebox_override("panel", new_stylebox)

func _on_close_btn_pressed():
	get_parent().hide()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			get_parent().hide()

func reset():
	$PC/MC/VB/VB/TitleValue.text = ""
	$PC/MC/VB/VB2/DescValue.text = ""

	_labels_chosen = []

	for node in _labels_node.get_children():
		var stylebox = node.get_stylebox("panel").duplicate()
		stylebox.set_bg_color(node.color)
		node.add_stylebox_override("panel", stylebox)

func _on_add_button_pressed():
	var labels_to_add = []
	for label in _labels_chosen:
		labels_to_add.append(label.get_data())

	var data = {
		"id": Datastore.gen_uuid(),
		"title": $PC/MC/VB/VB/TitleValue.text,
		"desc": $PC/MC/VB/VB2/DescValue.text,
		"labels": labels_to_add
	}

	if data.title == "":
		return

	var card = _card_scene.instance()
	card.from_data(data)

	column_to_add_to.get_cards_container().add_child(card)
	column_to_add_to.update_column()
	get_parent().hide()
