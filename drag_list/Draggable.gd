class_name Draggable
extends Control

var prefab : PackedScene

## Singular tween ref so we don't start tons of conflicting tweens
var tween : Tween

## The underlying data that this Draggable is rendering
var data : Variant

func init(data: Variant):
	self.data = data

func _get_drag_data(pos: Vector2):
	self.visible = false
	set_drag_preview(get_preview())
	return self

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			self.visible = true

func tween_to(pos: Variant, duration: float):
	## Disable mouse interactions during the tween
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	## If we're already in the middle of a tween, cancel it
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", pos, duration)
	await tween.finished
	
	## Re-enable mouse interactions
	self.mouse_filter = Control.MOUSE_FILTER_PASS

func get_preview():
	var preview := prefab.instantiate() as Control
	preview.init(self.data)
	var c = Control.new()
	c.add_child(preview)
	preview.position = self.size * -0.5
	return c
