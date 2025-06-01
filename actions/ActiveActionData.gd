extends RefCounted
class_name ActiveActionData

signal action_complete(active_action_data:ActiveActionData)
signal action_repeats_complete(active_action_data:ActiveActionData)
signal time_elapsed_updated()
signal repeat_count_updated()

static var UNKNOWN_ACTION := ActionData.new("Unknown Action", 1.0)

var action:ActionData
var time_elapsed:float = 0:
	set(v):
		time_elapsed = v
		time_elapsed_updated.emit()
var should_repeat_count:int = 1:
	set(v):
		should_repeat_count = v
		repeat_count_updated.emit()
var repeated_count:int = 0:
	set(v):
		repeated_count = v
		repeat_count_updated.emit()

static func empty_data() -> ActiveActionData:
	var result := ActiveActionData.new(UNKNOWN_ACTION, 0)
	return result

func _init(action:ActionData, elapsed:float = 0):
	self.action = action
	self.time_elapsed = elapsed

func reset() -> void:
	repeated_count = 0
	time_elapsed = 0

func update(time_to_pass:float) -> float:
	# return time remaining if there was extra
	while repeated_count < should_repeat_count and time_to_pass > 0:
		var time_to_use := minf(time_to_pass, action.time_required - time_elapsed)
		time_elapsed += time_to_use
		time_to_pass -= time_to_use
		if time_elapsed + 0.0000001 > action.time_required:
			repeated_count += 1
			action_complete.emit(self)
			if should_repeat_count > repeated_count:
				time_elapsed = 0
			else:
				action_repeats_complete.emit(self)
	return max(0, time_to_pass)
