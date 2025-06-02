extends Container
class_name ActionsList

@onready var entry_list:Container = find_child("EntryList")
var actions_list_data:ActionsListData:
	set(v):
		actions_list_data = v
		if v:
			actions_list_data.action_added.connect(on_entry_added)
			actions_list_data.action_removed.connect(on_entry_removed)
			actions_list_data.active_action_changed.connect(on_active_entry_changed)
			if actions_list_data:
				add_all_action_views()

func init(actions_list_data:ActionsListData) -> void:
	self.actions_list_data = actions_list_data

func _ready():
	if actions_list_data:
		add_all_action_views()

func add_all_action_views():
	if !entry_list:
		return
	for child in entry_list.get_children():
		child.queue_free()
	for i in range(actions_list_data.active_actions.size()):
		on_entry_added(actions_list_data.active_actions[i], i)

func on_entry_added(new_action:ActiveActionData, idx:int) -> void:
	var view = preload("res://actions/ActiveActionView.tscn").instantiate()
	view.init(new_action)
	entry_list.add_child(view)
	entry_list.move_child(view, idx)

func on_entry_removed(idx:int) -> void:
	var view = get_child(idx)
	if view and is_instance_valid(view):
		view.queue_free()

func on_active_entry_changed(old_idx:int, new_idx:int) -> void:
	print("New active entry idx: ", new_idx)
