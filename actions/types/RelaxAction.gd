extends ActionData

func _init():
	super("relax", 1.0)

func _action_complete(data:ActiveActionData):
	print("Resting...", data.source)
