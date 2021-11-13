extends Control

var column_scene = preload("res://scenes/Column.tscn")
var is_dragging = false

func _ready():
	load_columns()

	GlobalSignals.connect("add_item_modal_visible", self, "_on_add_item_modal_visible")

	$AddItemReference.visible = false
	$DeleteReference.visible = true

func load_columns():
	var board = Datastore.get_board()

	var columns_node = $MC/VB/SC/VB/Columns

	# Remove old columns
	for child in columns_node.get_children():
		child.visible = false
		child.queue_free()

	# Add new columns
	for column in board.columns:
		var column_instance = column_scene.instance()
		columns_node.add_child(column_instance)
		column_instance.set_data(column)

func _on_add_item_modal_visible(show, column):
	var add_item_modal = $AddItemReference
	if show:
		add_item_modal.visible = true
		add_item_modal.get_node("CC").reset()
		add_item_modal.get_node("CC").column_to_add_to = column
	else:
		add_item_modal.visible = false

func _process(_delta):
	# Check if a card is being dragged
	if get_viewport().gui_is_dragging():
		if not is_dragging:
			$AnimationPlayer.play("show_dropdelete")
			is_dragging = true
	elif is_dragging:
		$AnimationPlayer.play_backwards("show_dropdelete")
		is_dragging = false
		GlobalSignals.emit_card_mouse_filter(MOUSE_FILTER_STOP)
