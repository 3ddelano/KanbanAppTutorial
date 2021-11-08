extends CenterContainer

onready var _close_btn = $PC/MC/VB/HB/CloseBtn

func _ready():
	_close_btn.connect("pressed", self, "_on_close_btn_pressed")
	connect("gui_input", self, "_on_gui_input")

func _on_close_btn_pressed():
	get_parent().hide()

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			get_parent().hide()

func reset():
	pass
