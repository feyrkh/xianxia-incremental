extends MarginContainer

@onready var progress_bar:ProgressBar = find_child("ProgressBar")
@onready var label:Label = find_child("Label")
@export var color:Color = Color.WHITE:
	set(v):
		color = v
		if progress_bar:
			progress_bar.modulate = color
var value:ResourceValue:
	set(v):
		if value:
			value.updated.disconnect(refresh)
		value = v
		value.updated.connect(refresh)
		refresh(value)

func _ready() -> void:
	progress_bar.modulate = color
	if value:
		refresh(value)

func refresh(res:ResourceValue) -> void:
	if label:
		label.text = "%s: %d / %d" % [res.label, res.value, res.max_value]
	if progress_bar:
		progress_bar.max_value = res.max_value
		progress_bar.value = res.value
