extends Control

@onready var active_actions_list = find_child("ActionsListView")

var actions_list_data:ActionsListData = ActionsListData.new()

func _ready():
	for i in range(20):
		var cultivator:CultivatorData = CultivatorData.new_cultivator("Wandering Cultivator "+str(i))
		CultivatorMgr.add_cultivator(cultivator)
		find_child("CultivatorsContainer").datasource = CultivatorMgr
