extends Node2D
export var direction = Vector2(0, 0)
export var speed = 1200
var teleport_area = false

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func can_teleport():
	return teleport_area

func _on_a2d_teleport_body_enter( body ):
	teleport_area = true
	pass # replace with function body
	
	
func _on_a2d_teleport_body_exit( body ):
	teleport_area = true
	pass # replace with function body
