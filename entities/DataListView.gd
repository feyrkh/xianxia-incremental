extends Container

@export var render_type:String = ""

var datasource:
	set(v):
		if datasource and datasource.has_signal("updated"):
			datasource.updated.disconnect(refresh)
		datasource = v
		if datasource and datasource.has_signal("updated"):
			datasource.updated.connect(refresh)
		refresh()

func refresh(data=null) -> void:
	if !datasource:
		return
	for child in get_children():
		child.queue_free()
	var items_to_render 
	if (render_type == null) or (render_type == ""):
		items_to_render = datasource.data_to_render()
	else:
		items_to_render = datasource.data_to_render(render_type)
	for entry in items_to_render:
		var rendered_item = data_entry_to_rendered_control(entry)
		if rendered_item:
			add_child(rendered_item)

func data_entry_to_rendered_control(entry, render_data = null) -> Control:
	var rendered_item
	if entry == null:
		return null
	if entry is Control:
		rendered_item = entry
	elif entry is Dictionary:
		rendered_item = data_entry_to_rendered_control(entry.get("value"), entry.get("render_data", null))
		for k in entry:
			if k != "value":
				rendered_item.set(k, entry.get(k))
	elif entry.has_method("rendered"):
		if render_data != null:
			rendered_item = entry.rendered(render_data)
		else:
			rendered_item = entry.rendered()
	return rendered_item
	
func _ready() -> void:
	refresh()
