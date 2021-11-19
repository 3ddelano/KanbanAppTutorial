extends PanelContainer
signal on_update

var _data = {
	"title": "Card title here",
	"labels": [
		{
			"name": "Blue label",
			"color": "#5076e7"
		},
		{
			"name": "Yellow label",
			"color": "#dfcb26"
		}
	],
	"desc": "Test description here",
	#time here
}

var _label_scene = preload("res://scenes/ColorLabel.tscn")
var _style_normal = preload("res://scenes/CardStyleBoxNormal.tres")
var _style_hover = preload("res://scenes/CardStyleBoxHover.tres")

func get_title():
	return _data.title

func set_title(new_title):
	_data.title = new_title
	emit_signal("on_update")

func get_labels():
	return _data.labels

func set_labels(new_labels):
	_data.labels = new_labels
	emit_signal("on_update")

func _ready():
	_on_update()
	connect("on_update", self, "_on_update")
	GlobalSignals.connect("card_mouse_filter", self, "_set_mouse_filter")

func _on_update():
	$MC/VB/Title.text = str(_data.title)

	var labels_node = $MC/VB/Labels
	for child in labels_node.get_children():
		child.visible = false
		child.queue_free()

	for label in _data.labels:
		# make a new label
		var label_instance = _label_scene.instance()
		label_instance.color = Color(label.color)
		labels_node.add_child(label_instance)

	if _data.desc and _data.desc.length() > 0:
		$MC/VB/Desc.visible = true
	else:
		$MC/VB/Desc.visible = false

func from_data(data):
	_data = data
	emit_signal("on_update")

func _set_mouse_filter(new_filter):
	mouse_filter = new_filter
	if new_filter == MOUSE_FILTER_PASS:
		$Overlay.visible = false
	elif new_filter == MOUSE_FILTER_STOP:
		$Overlay.visible = true
		add_stylebox_override("panel", _style_normal)

func get_drag_data(position):
	$Overlay.visible = false
	add_stylebox_override("panel", _style_hover)

	# Make preview
	var preview = self.duplicate()
	preview.add_stylebox_override("panel", _style_normal)
	preview.from_data(_data)
	set_drag_preview(preview)

	GlobalSignals.emit_card_mouse_filter(MOUSE_FILTER_PASS)
	return self
