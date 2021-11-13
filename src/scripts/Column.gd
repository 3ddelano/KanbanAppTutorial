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


func get_cards_container():
	return $MC/VB/SC/HB/Cards

func update_column():
	_data.cards = []

	for node in $MC/VB/SC/HB/Cards.get_children():
		_data.cards.append(node._data)

	if _data.has("id") and _data.id != "":
		Datastore.update_column(_data)

func can_drop_data(position, data):
	return true

func drop_data(pos, card):
	# Unparent the card from old_column and update that column
	var old_cards_container: VBoxContainer = card.get_parent()
	old_cards_container.remove_child(card)
	old_cards_container.get_column().update_column()

	var new_cards_container: VBoxContainer = $MC/VB/SC/HB/Cards
	var new_scroll_container: ScrollContainer = $MC/VB/SC

	# Find index in list relative to mouse position
	var insert_index = find_closest_child_to_mouse(pos, new_cards_container, new_scroll_container)

	new_cards_container.add_child(card)
	new_cards_container.move_child(card, insert_index)
	update_column()

	# Make the cards clickable again
	GlobalSignals.emit_card_mouse_filter(MOUSE_FILTER_STOP)

func find_closest_child_to_mouse(mouse_pos, container, container_scroll) -> int:
	var closest_child
	var last_distance : float = -1

	# Calculate the actual mouse position in the scroll container
	var actual_y = mouse_pos.y + container_scroll.get_v_scroll()
	var scrolled_mouse_pos := Vector2(mouse_pos.x, actual_y)
	var top_margin = container_scroll.get_position().y

	# Find the closest child to the mouse position
	for child in container.get_children():
		var distance:float = abs(child.get_position().y + top_margin - scrolled_mouse_pos.y)
		if last_distance == -1 or (distance < last_distance):
			last_distance = distance
			closest_child = child

	# No cards in the column, so insert at the top
	if not closest_child:
		return 0 # Insert at top

	# Find the correct index of the position to insert card
	var closest_index = closest_child.get_index()
	var y = closest_child.get_position().y + top_margin
	var height = closest_child.get_size().y
	var mid = y + (height * 0.5)

	if scrolled_mouse_pos.y <= (mid):
		# Insert before
		return closest_index # Insert before
	else:
		# Insert after
		return closest_index + 1 # Insert after
