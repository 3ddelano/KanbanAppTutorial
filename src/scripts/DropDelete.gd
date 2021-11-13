extends PanelContainer

func can_drop_data(position, data):
	return true

func drop_data(pos, card):
	# Unparent the card from old_column and update that column
	var old_cards_container: VBoxContainer = card.get_parent()
	old_cards_container.remove_child(card)
	old_cards_container.get_column().update_column()

	GlobalSignals.emit_card_mouse_filter(MOUSE_FILTER_STOP)

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()

	if get_rect().has_point(mouse_pos):
		$Overlay.visible = true
	else:
		$Overlay.visible = false
