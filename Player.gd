extends KinematicBody2D

var velocity = Vector2()
export var speed = 300
export var gravity = 10
export var jumpforce = 400
export var jumptime = 15
export var wallslidespd = 50
export var accel = 0.075

export var walljumpforce = 1000

var currentspeed = 0
var airtime = 0

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("left"):
		currentspeed -= accel
		if currentspeed > 0:
			currentspeed = 0
	if Input.is_action_pressed("right"):
		currentspeed += accel
		if currentspeed < 0:
			currentspeed = 0
	
	if (!Input.is_action_pressed("left") && !Input.is_action_pressed("right")) && is_on_floor():
		currentspeed = currentspeed * 0.75
	
	match(get_wall()):
		1:
			currentspeed = clamp(currentspeed, -1, 0)
		-1:
			currentspeed = clamp(currentspeed, 0, 1)
		0:
			currentspeed = clamp(currentspeed, -1, 1)
	velocity.x = currentspeed * speed

func grav():
	if is_on_floor():
		velocity.y = 0
		airtime = 0
	else: 
		if get_wall() == 0:
			velocity.y += gravity
		else:
			velocity.y += gravity
			velocity.y = clamp(velocity.y, -999, wallslidespd)
		airtime += 1
		if Input.is_action_just_released("jump"):
			airtime = jumptime
			velocity.y = velocity.y/1.5
	
	if Input.is_action_pressed("jump") && airtime < jumptime:
		velocity.y = -jumpforce
	if Input.is_action_just_pressed("jump") && get_wall() != 0:
		velocity.y = -walljumpforce
		velocity.x = walljumpforce * -get_wall()
		

func get_wall():
	if $RayLeft.is_colliding() or $RayLeftBottom.is_colliding() or $RayLeftTop.is_colliding():
		return -1
	if $RayRight.is_colliding() or $RayRightBottom.is_colliding() or $RayRightTop.is_colliding():
		return 1
	return 0

	
func _physics_process(delta):
	get_input()
	grav()
	move_and_slide(velocity, Vector2.UP)
