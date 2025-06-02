extends Container

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
	var items_to_render = datasource.data_to_render()
	for entry in items_to_render:
		var rendered_item
		if entry is Dictionary:
			rendered_item = entry.get("value").rendered()
			for k in entry:
				if k != "value":
					rendered_item.set(k, entry.get(k))
		elif entry.has_method("rendered"):
			rendered_item = entry.rendered()
		if rendered_item:
			add_child(rendered_item)

func _ready() -> void:
	refresh()
