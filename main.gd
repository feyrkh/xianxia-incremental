extends Control

@onready var active_actions_list = find_child("ActionsListView")

var actions_list_data:ActionsListData = ActionsListData.new()

func _ready():
	var meditate:ActionData = ActionData.new("meditate", 1.0)
	var meditate_entry:ActiveActionData = ActiveActionData.new(meditate)
	var rest:ActionData = ActionData.new("rest", 1.0)
	var rest_entry:ActiveActionData = ActiveActionData.new(rest, 0)
	rest_entry.should_repeat_count = 3
	actions_list_data.add_entry(meditate_entry)
	actions_list_data.add_entry(rest_entry)
	active_actions_list.init(actions_list_data)
	ActionMgr.add_action_list(actions_list_data)
