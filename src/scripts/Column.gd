extends PanelContainer
signal on_update

var _card_scene = preload("res://scenes/Card.tscn")

var _data = {
	"name": "Untitled",
	"cards": []
}

func set_data(new_data):
	_data = new_data
	emit_signal("on_update")

func _ready():
	_on_update()
	connect("on_update", self, "_on_update")
	$MC/VB/Button.connect("pressed", self, "_on_add_item_button_pressed")


func _on_update():

	var cards_node = $MC/VB/SC/HB/Cards

	# Remove old cards
	for child in cards_node.get_children():
		child.visible = false
		child.queue_free()

	# Add new cards
	for card in _data.cards:
		var card_instance = _card_scene.instance()
		card_instance.from_data(card)
		cards_node.add_child(card_instance)

	if _data.has("name") and _data.name != "":
		$MC/VB/Title.text = str(_data.name)
	else:
		$MC/VB/Title.text = "Untitled"

func _on_add_item_button_pressed():
	GlobalSignals.show_add_item(self)
