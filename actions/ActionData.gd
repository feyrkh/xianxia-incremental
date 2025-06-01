extends RefCounted
class_name ActionData

var action_name:String = "Some Action"
var time_required:float = 1.0

func _init(n:String, t:float):
	action_name = n
	time_required = t
