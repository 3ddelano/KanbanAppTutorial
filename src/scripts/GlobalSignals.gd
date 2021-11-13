extends Node

signal add_item_modal_visible(value, column)
signal card_mouse_filter(val)

func show_add_item(column):
	emit_signal("add_item_modal_visible", true, column)

func emit_card_mouse_filter(val):
	emit_signal("card_mouse_filter", val)
