extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var checkpoint_num = 1

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func check_area(b):
	return overlaps_body(b)

