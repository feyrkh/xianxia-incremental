extends Node

var action_lists:Array[ActionsListData] = []

func _process(delta:float) -> void:
	for action_list in action_lists:
		action_list.update(delta)

func add_action_list(action_list:ActionsListData) -> void:
	if !action_lists.has(action_list):
		action_lists.append(action_list)
