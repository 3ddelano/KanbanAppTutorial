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

var _label_scene = load("res://scenes/ColorLabel.tscn")

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

func _on_update():
	$MC/VB/Title.text = str(_data.title)

	var labels_node = $MC/VB/Labels
	for label in _data.labels:
		# make a new label
		var label_instance = _label_scene.instance()
		label_instance.color = Color(label.color)
		labels_node.add_child(label_instance)

	if _data.desc and _data.desc.length() > 0:
		$MC/VB/Desc.visible = true
	else:
		$MC/VB/Desc.visible = false
