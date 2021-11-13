extends VBoxContainer

export (NodePath) var column_path

func get_column():
	return get_node(column_path)
