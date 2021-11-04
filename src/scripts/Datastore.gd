extends Node

static func rand_int():
	randomize()
	return randi() % 256

static func gen_uuid() -> String:
	var b = [
		rand_int(), rand_int(), rand_int(), rand_int(),
		rand_int(), rand_int(), ((rand_int()) & 0x0f) | 0x40, rand_int(),
		((rand_int()) & 0x3f) | 0x80, rand_int(), rand_int(), rand_int(),
		rand_int(), rand_int(), rand_int(), rand_int()
	]
	return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
		b[0], b[1], b[2], b[3],
		b[4], b[5],
		b[6], b[7],
		b[8], b[9],
		b[10], b[11], b[12], b[13], b[14], b[15]
	]

const SAVE_LOCATION = "user://kanban_board.save"
var default_board = {
	"columns": [
		{
			"id": gen_uuid(),
			"name": "In progress",
			"cards": []
		},
		{
			"id": gen_uuid(),
			"name": "Done",
			"cards": []
		},
		{
			"id": gen_uuid(),
			"name": "TODO",
			"cards": []
		}
	]
}

var _board = {} setget set_board, get_board

func set_board(new_board):
	_board = new_board

func get_board():
	return _board

func save_board():
	var file = File.new()
	file.open(SAVE_LOCATION, File.WRITE)
	file.store_string(var2str(_board))
	file.close()

func load_board():
	var file = File.new()
	file.open(SAVE_LOCATION, File.READ)
	var content = file.get_as_text()
	file.close()

	if content:
		_board = str2var(content)
	else:
		_board = default_board.duplicate(true)

func _ready():
	load_board()

func update_columns(new_column):
	var did_change = false
	for column in _board.columns:
		if column.id == new_column.id:
			column = new_column
			did_change = true

	if did_change:
		save_board()
