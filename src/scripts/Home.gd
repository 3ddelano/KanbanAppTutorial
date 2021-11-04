extends Control

var column_scene = preload("res://scenes/Column.tscn")

func _ready():
	load_columns()


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


