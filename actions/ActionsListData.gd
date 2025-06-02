extends RefCounted
class_name ActionsListData 

signal active_action_changed(old_idx, new_idx)
signal action_added(new_action, idx)
signal action_removed(idx)
signal list_completed()

var active_actions:Array[ActiveActionData] = []
var cur_idx := -1:
	set(v):
		if v != cur_idx:
			active_action_changed.emit(cur_idx, v)
			cur_idx = v

func rendered() -> Control:
	var result = preload("res://actions/ActionsListView.tscn").instantiate()
	result.actions_list_data = self
	return result

func add_entry(action:ActiveActionData) -> void:
	active_actions.append(action)
	if cur_idx == -1 || cur_idx >= active_actions.size():
		cur_idx = 0
	subscribe_action_events(action)
	action_added.emit(action, active_actions.size() - 1)

func remove_entry_idx(idx:int):
	if idx < 0 or idx >= active_actions.size():
		return
	var removing:ActiveActionData = active_actions.get(idx)
	active_actions.remove_at(idx)
	action_removed.emit(idx)

func update(time_to_pass:float):
	while time_to_pass > 0:
		if active_actions.size() == 0:
			return
		time_to_pass = active_actions[cur_idx].update(time_to_pass)

func next_action() -> void:
	unhighlight(cur_idx)
	cur_idx += 1
	if active_actions.size() == 0:
		cur_idx = -1
	elif cur_idx >= active_actions.size():
		cur_idx = 0
		print("all actions complete, resetting")
		for action in active_actions:
			action.reset()
		list_completed.emit()
	highlight(cur_idx)

func highlight(idx:int) -> void:
	if idx < 0 or idx >= active_actions.size():
		return
	pass

func unhighlight(idx:int) -> void:
	if idx < 0 or idx >= active_actions.size():
		return
	pass
	
func subscribe_action_events(action:ActiveActionData) -> void:
	action.action_repeats_complete.connect(func(next_action_data:ActiveActionData): next_action())
