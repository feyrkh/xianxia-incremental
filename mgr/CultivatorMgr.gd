extends IdMgr

var cultivator_order:Array[CultivatorData] = []

func add_cultivator(entry:CultivatorData) -> int:
	cultivator_order.append(entry)
	return _index(entry)

func remove_cultivator(entry:CultivatorData) -> void:
	cultivator_order.erase(entry)
	_remove(entry)

func get_by_id(id:int) -> CultivatorData:
	return _get_by_id(id) as CultivatorData

func data_to_render():
	return cultivator_order

func _process(delta:float) -> void:
	for cultivator in get_entries():
		cultivator.update(delta)
