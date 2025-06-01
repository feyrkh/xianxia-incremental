class_name ReorderableList
extends Control

enum Direction { HORIZONTAL, VERTICAL }

## Dependencies
var data : Array[Variant]

## Local props
@export var draggable_prefab : PackedScene
@export var drop_target_prefab : PackedScene
@export var direction : Direction = Direction.HORIZONTAL
## Maps data instances to their Draggable counterpart
var data_to_draggable = {}
var draggable_to_data = {}

## Local refs
@onready var horizontal_container = $HorizontalContainer
@onready var drop_targets : Array[DropTarget] = []
@onready var vertical_container = $VerticalContainer

func init(data: Array[Variant]):
	self.data = data
	for i in range(data.size()):
		var d = data[i]
		
		## Create drop targets for draggables
		var drop_target := drop_target_prefab.instantiate() as DropTarget
		drop_targets.append(drop_target)
		
		## Set hover handler for drop targets when dragging
		## We do this here instead of drop_target.gd to create a closure
		## for mutating the data array
		drop_target.hover_callback = on_drop_target_hover
		
		## Add drop target to the appropriate container
		if self.direction == Direction.HORIZONTAL:
			horizontal_container.add_child(drop_target)
		else:
			vertical_container.add_child(drop_target)
		
		## Create a draggable for each piece of data
		var draggable := draggable_prefab.instantiate() as Draggable
		## Let the Draggable know what prefab to use for its drag preview
		draggable.prefab = draggable_prefab
		## Mapping between each Draggable and the piece of data it 
		## represents.
		## `data_to_draggable` is used for rerendering mutations to the
		## underlying data. For each piece of data, we need a reference to the
		## Draggable that represents it.
		data_to_draggable[d] = draggable
		
		## `draggable_to_data` is used for finding the current index
		## of the Draggable's underlying data in the self.data array.
		## We use this in the drop_target.gd hover callback to find out
		## which index item we should swap with the hovered drop_target's item.
		draggable_to_data[draggable] = d
		
		drop_target.add_child(draggable)
		draggable.init(d)
		drop_target.custom_minimum_size = draggable.size

func on_drop_target_hover(dt: DropTarget, d: Draggable):
	## Get the index of the Draggable's data in self.data
	## NOTE: IDK WHY, but for some reason just using d.data doesn't
	## work here. Maybe something to do with scene tree hierarchy, which
	## our `draggable_to_data` map is independent of?
	var curr_data_index = self.data.find(draggable_to_data[d])
	
	## Get the index of the drop target
	var drop_target_index = self.drop_targets.find(dt)
	
	## Swap the data piece being dragged with the data piece in
	## the hovered DropTarget slot
	var swapped = swap(self.data, curr_data_index, drop_target_index)
	
	## Only rerender if the data has actually mutated
	if swapped:
		rerender()

func swap(arr, i, j):
	if (i != j):
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp
		return true
	return false

func rerender():
	## Used to rerender the SortableList AFTER a mutation has occurred to the
	## underlying data. At the beginning of this function, the indices of
	## each piece of data may be out of sync with the order it is rendered.
	for i in range(self.data.size()):
		## For each piece of data, find the Draggable that represents it
		var draggable := self.data_to_draggable[self.data[i]] as Draggable
		
		## Its new parent (position) is going to be the index of the DropTarget
		## that matches the data's index in self.data
		var new_parent = self.drop_targets[i]
		
		## Save the old global position so we can smoothly tween from it to the
		## new position
		var old_global_pos = draggable.global_position
		
		## Swapping parents snaps the position to the new parent, so immediately
		## set the position to the old global position so we can smoothly tween
		## to the new one. We do this instead of calling tween.from() so that we
		## can tween the local position to (0, 0) instead of figuring out which
		## global_position to tween to.
		draggable.get_parent().remove_child(draggable)
		new_parent.add_child(draggable)
		draggable.global_position = old_global_pos
		draggable.tween_to(Vector2.ZERO, 0.1)
