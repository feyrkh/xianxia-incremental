extends ColorRect
class_name SelectHandle

@export var signal_name:String
var signal_data:Object
var selected:bool = false

func _ready() -> void:
	EventBus.connect(signal_name, on_my_signal)

func on_my_signal(signal_data:Object) -> void:
	if signal_data == self.signal_data:
		selected = true
		color = Color.WHITE
	else:
		selected = false
		color = Color.DARK_GRAY

func _on_gui_input(event: InputEvent) -> void:
	if signal_name and event.is_action("ui_click"):
		trigger_click()

func trigger_click() -> void:
	if signal_name:
		EventBus.emit_signal(signal_name, signal_data)
