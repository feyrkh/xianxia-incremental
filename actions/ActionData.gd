extends RefCounted
class_name ActionData

var action_name:String = "Some Action"
var time_required:float = 1.0

func _init(n:String, t:float):
	action_name = n
	time_required = t

func get_instance(src=null, target=null, context=null) -> ActiveActionData:
	if target == null:
		target = src
	var instance := ActiveActionData.new(self, 0, src, target, context)
	return instance
