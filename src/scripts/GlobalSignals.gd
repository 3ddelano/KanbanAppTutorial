extends Node

signal add_item_modal_visible(value, column)

func show_add_item(column):
	emit_signal("add_item_modal_visible", true, column)
