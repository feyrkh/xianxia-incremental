extends RefCounted
class_name ResourceValue

signal updated(res:ResourceValue)

var label:String = "Unknown Resource":
	set(v):
		label = v
		updated.emit(self)
var value:float = 0:
	set(v):
		value = v
		updated.emit(self)
var max_value:float = 100:
	set(v):
		max_value = v
		updated.emit(self)

func _init(label:String, value:float, max_value:float):
	self.label = label
	self.value = value
	self.max_value = max_value

func rendered() -> Control:
	var result = preload("res://values/ResourceProgressBar.tscn").instantiate()
	result.value = self
	return result
