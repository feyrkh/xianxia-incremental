extends HBoxContainer
class_name EditStringValueView

@onready var label:Label = find_child("Label")

var value:StringValue:
	set(v):
		if value:
			value.updated.disconnect(refresh)
		value = v
		value.updated.connect(refresh)

func refresh(v:StringValue) -> void:
	if value and label:
		label.text = value.value

func _ready() -> void:
	refresh(value)

func show_edit_buttons(v:bool) -> void:
	find_child("SaveButton").visible = v
	find_child("CancelButton").visible = v
	find_child("LineEdit").visible = v
	#find_child("EditButton").visible = !v
	find_child("Label").visible = !v
	if v:
		find_child("LineEdit").text = find_child("Label").text
		find_child("LineEdit").grab_focus()
		find_child("LineEdit").select_all()

func _on_edit_button_pressed() -> void:
	show_edit_buttons(true)

func _on_save_button_pressed() -> void:
	show_edit_buttons(false)
	var new_text:String = find_child("LineEdit").text
	if !new_text.strip_edges().is_empty() and value:
		value.value = new_text

func _on_cancel_button_pressed() -> void:
	show_edit_buttons(false)

func _on_line_edit_text_submitted(new_text: String) -> void:
	_on_save_button_pressed()

func _on_line_edit_focus_exited() -> void:
	_on_cancel_button_pressed()

func _on_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.double_click:
			_on_edit_button_pressed()

func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		_on_cancel_button_pressed()
