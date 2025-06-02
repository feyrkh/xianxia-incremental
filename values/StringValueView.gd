extends Label

var value:StringValue:
	set(v):
		if value:
			value.updated.disconnect(refresh)
		value = v
		value.updated.connect(refresh)

func refresh(v:StringValue) -> void:
	if value:
		text = value.value

func _ready() -> void:
	refresh(value)
