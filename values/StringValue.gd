extends RefCounted
class_name StringValue

signal updated(res:ResourceValue)

var value:String = "Unknown String":
	set(v):
		value = v
		updated.emit(self)

var editable:bool = false

func _init(v:String):
	value = v

func rendered() -> Control:
	var result
	if !editable:
		result = preload("res://values/StringValueView.tscn").instantiate()
	else:
		result = preload("res://values/EditStringValueView.tscn").instantiate()
	result.value = self
	return result

func set_editable(v:bool) -> StringValue:
	editable = v
	return self
