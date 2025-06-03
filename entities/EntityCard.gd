extends PanelContainer

@onready var handle:SelectHandle

func _on_gui_input(event: InputEvent) -> void:
	if !handle:
		handle = find_children("*", "SelectHandle", true, false).front()
	if handle and event.is_action("ui_click"):
		handle.trigger_click()
