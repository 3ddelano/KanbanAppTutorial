tool
extends PanelContainer

signal on_update

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
