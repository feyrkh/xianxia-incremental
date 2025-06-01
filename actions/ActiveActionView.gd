extends Container
class_name ActiveActionView

@onready var progress_bar:ProgressBar = find_child("ProgressBar")
@onready var label:Label = find_child("Label")
var active_action_data:ActiveActionData

func init_child_var(var_name:String, child_name:String) -> Node:
	var child = get(var_name)
	if child: return child
	set(var_name, find_child(child_name))
	return get(var_name)

func init(active_action_data:ActiveActionData = null) -> void:
	init_child_var("label", "Label")
	init_child_var("progress_bar", "ProgressBar")
	if self.active_action_data != null:
		self.active_action_data.time_elapsed_updated.disconnect(update_progress)
		self.active_action_data.repeat_count_updated.disconnect(update_label)
	if active_action_data == null:
		active_action_data = ActiveActionData.empty_data()
	self.active_action_data = active_action_data
	self.active_action_data.time_elapsed_updated.connect(update_progress)
	self.active_action_data.repeat_count_updated.connect(update_label)
	update_progress()
	update_label()

func refresh():
	update_progress()
	update_label()

func update_progress() -> void:
	var complete_pct := active_action_data.time_elapsed / active_action_data.action.time_required
	progress_bar.value = complete_pct

func update_label() -> void:
	find_child("Label").text = "%s (%.1fs)%s" % [active_action_data.action.action_name, active_action_data.action.time_required, "" if active_action_data.should_repeat_count <= 1 else " [%d/%d]" % [active_action_data.repeated_count, active_action_data.should_repeat_count]]
