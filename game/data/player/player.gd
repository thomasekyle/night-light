extends KinematicBody2D
#Member Variables

#Player Variables
var invincible = false
var i_timer = 0
var flash_timer = 0


#Physics Variables
export var grav = 1000
export var JUMP_FORCE = 350
export var SPEED=100
export var ACCELERATION=500
export var DECCELERATION=900
export var MAX_SPEED=250
var speed_x=0
var speed_y=0
var velocity=Vector2()
var input_direction=0
var direction=0
var flip=false
var falling=true
var jumps=1
var moving=false
var move_remainder

#Teleport
var teleport_speed = 2000
var teleport_shot = 1
var teleporting = false

#Flashlight
var flashlight_shot = 1
var using_flashlight = false

var shadow = 0.1
var d = 0.01668
var spring = false
var up_pushed = false

func _ready():
	set_process(true)
	set_process_input(true)

func _input(event):
	if (Input.is_action_pressed("ui_up")):
		up_pushed = true
	else:
		up_pushed = false
	if (event != null):
		moving=true
	else:
		moving=false
	if (Input.is_action_pressed("ui_accept") and jumps > 0):
		speed_y = -JUMP_FORCE
		Sound.play("jump")
		jumps-=1

	#If the player presses the shoot button they will fire a projectile. If they then again press the shoot
	#button again then they will teleport to the location of the bullet. (Barring that there is enough space.)
	#If there is not enough space the player will not teleport
	if (Input.is_action_pressed("ui_shoot")):
		if (teleporting):
			if (get_parent().get_node("bullet.tscn").can_telport()):
				set_pos(get_parent().get_node("bullet.tscn").get_pos())
			else:
				pass
		else:
			var bullet = load("res://data/player/bullet.tscn")
			bullet.set_pos(get_node("pnt_shoot").get_pos())
			if (get_node("anim_player").is_flipped_h()):
				bullet.direction = Vector2(-1, 0)
			else:
				bullet.direction = Vector2(1, 0)
			var b = bullet.instance()
			get_parent().add_child(b)


func _process(delta):
	if (Input.is_action_pressed("ui_up")):
		up_pushed = true
	else:
		up_pushed = false

	if (i_timer > 0):
		if (flash_timer > 0):
			flash_timer-=delta
			get_node("anim_player").hide()
		else:
			get_node("anim_player").show()
			i_timer-=1
			flash_timer = .125

	else:
		invincible == false
		JUMP_FORCE = 350
		show()

	if input_direction:
		direction = input_direction

	if Input.is_action_pressed("ui_left"):
		get_node("anim_player").set_animation("moving")
		get_node("anim_player").set_flip_h(true)
		input_direction = -1
	elif Input.is_action_pressed("ui_right"):
		get_node("anim_player").set_animation("moving")
		get_node("anim_player").set_flip_h(false)
		input_direction = 1
	else:
		input_direction = 0
		get_node("anim_player").set_animation("default")

	if input_direction !=  direction:
		speed_x /= 3
	if input_direction:
		speed_x += ACCELERATION * delta
	else:
		speed_x -= DECCELERATION * delta

	speed_x = clamp(speed_x, 0 , MAX_SPEED)

	#Add Gravity
	speed_y += grav * delta
	if jumps < 1:
		get_node("anim_player").set_animation("jumping")
	speed_y = clamp(speed_y, -800 , 1700)

	velocity.x = speed_x * delta * direction
	velocity.y = speed_y * delta
	move_remainder = move(velocity)



	if is_colliding():
		var normal = get_collision_normal()
		if normal.y < 0:
			if jumps < 1:
				Sound.play("landing")
			jumps = 1
			grav = 0


		var slide = normal.slide(move_remainder)
		speed_y = normal.slide(Vector2(0, speed_y)).y
		#speed_y = 0
		if moving:
			move(slide)

	else:
		grav = 1000


func get_col_vel(o):
	var cols = get_parent().get_node("Platforms").get_children()
	for i in cols:
		if (i.get_instance_ID() == o.get_instance_ID()):
			return i.get_velocity()
