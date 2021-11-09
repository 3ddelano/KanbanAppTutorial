tool
extends PanelContainer

signal on_update
signal input_event(node, event)

export var color: Color setget set_color
export var text: String setget set_text

var colorlabel_stylebox = load("res://scenes/ColorLabelStyleBox.tres")

func set_color(new_color: Color):
	color = new_color
	emit_signal("on_update")

func set_text(new_text: String):
	text = new_text
	emit_signal("on_update")

func _init():
	if Engine.is_editor_hint():
		connect("on_update", self, "_on_update")

func _ready():
	_on_update()
	connect("on_update", self, "_on_update")


func _on_update():
	var stylebox = colorlabel_stylebox.duplicate()
	stylebox.set_bg_color(color)


	var label = $MC/Label

	if text.length() > 0:
		$MC.visible = true
		label.text = text

		stylebox.corner_radius_top_left = 5
		stylebox.corner_radius_top_right = 5
		stylebox.corner_radius_bottom_left = 5
		stylebox.corner_radius_bottom_right = 5

	else:
		stylebox.corner_radius_top_left = 10
		stylebox.corner_radius_top_right = 10
		stylebox.corner_radius_bottom_left = 10
		stylebox.corner_radius_bottom_right = 10
		$MC.visible = false
		visible = false
		call_deferred("set_visible", true)


	add_stylebox_override("panel", stylebox)

func set_clickable(val):
	if val:
		mouse_filter = MOUSE_FILTER_STOP
		mouse_default_cursor_shape = CURSOR_POINTING_HAND
		connect("gui_input", self, "_on_gui_input")
	else:
		mouse_filter = MOUSE_FILTER_PASS
		mouse_default_cursor_shape = CURSOR_ARROW
		disconnect("gui_input", self, "_on_gui_input")

func _on_gui_input(event: InputEvent):
	emit_signal("input_event", self, event)

func get_data():
	return {
		"name": text,
		"color": color
	}
