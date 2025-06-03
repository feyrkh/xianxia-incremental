extends RefCounted
class_name CultivatorData

var id:int
var char_name:StringValue = StringValue.new("Wandering Cultivator").set_editable(true)
var hp:ResourceValue = ResourceValue.new("HP", 100, 100)
var mana:ResourceValue = ResourceValue.new("Mana", 0, 10)
var action_queue:ActionsListData = ActionsListData.new()
var personal_actions:Array[ActionData] = []

static func new_cultivator(name:String) -> CultivatorData:
	var res := CultivatorData.new()
	res.char_name.value = name
	var rest_action := ActionData.new("rest", 1.0)
	res.personal_actions.append(rest_action)
	res.action_queue.add_entry(rest_action.get_instance(res))
	res.action_queue.add_entry(rest_action.get_instance(res).set_should_repeat_count(3))
	return res

func update(delta:float) -> void:
	action_queue.update(delta)

func data_to_render(render_type = "") -> Array:
	if !render_type or render_type == "card":
		var select_handle:SelectHandle = preload("res://entities/SelectHandle.tscn").instantiate()
		select_handle.signal_name = "cultivator_selected"
		select_handle.signal_data = self
		return [
			select_handle,
			{"value": char_name, "horizontal_alignment": 1, "editable": true},
			{"value": hp, "color": Color.DARK_GREEN}, # These build ResourceProgressBar objects, so we can set the properties of that object here
			{"value": mana, "color": Color.DARK_BLUE},
			{"value": action_queue, "short_action_list": true},
		]
	else:
		return [
			{"value": char_name, "horizontal_alignment": 1, "editable": true},
			{"value": hp, "color": Color.DARK_GREEN}, # These build ResourceProgressBar objects, so we can set the properties of that object here
			{"value": mana, "color": Color.DARK_BLUE},
			{"value": action_queue, "short_action_list": false},
		]
		

func rendered() -> Control:
	var card := preload("res://entities/EntityCard.tscn").instantiate()
	var data_view := preload("res://entities/DataListView.tscn").instantiate()
	card.add_child(data_view)
	data_view.datasource = self
	return card
