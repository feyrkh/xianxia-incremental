extends Node
class_name IdMgr

signal updated(mgr:IdMgr)

var _id_to_entry:Dictionary[int, Object] = {}
var _entry_to_id:Dictionary[Object, int] = {}
var _next_id:int = 0

func _index(new_entry) -> int:
	if _entry_to_id.has(new_entry):
		return _entry_to_id[new_entry]
	var new_id = _next_id
	_next_id += 1
	_id_to_entry[_next_id] = new_entry
	_entry_to_id[new_entry] = _next_id
	new_entry.set("id", new_id)
	updated.emit(self)
	return new_id
	
func _remove(old_entry) -> void:
	if _entry_to_id.has(old_entry):
		var old_id = _entry_to_id[old_entry]
		_id_to_entry.erase(old_id)
		_entry_to_id.erase(old_entry)
		updated.emit(self)

func _get_by_id(id:int) -> Object:
	return _id_to_entry.get(id, null)

func _get_id(entry:Object) -> int:
	return _entry_to_id.get(entry, null)

func get_entries() -> Array:
	return _id_to_entry.values()

func foreach(callable:Callable) -> void:
	for entry in _entry_to_id.keys():
		callable.call(entry)
