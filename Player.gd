extends KinematicBody2D

var velocity = Vector2()
export var speed = 300
export var gravity = 10
export var jumpforce = 45
export var jumptime = 15

var airtime = 0

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1
	velocity.x = velocity.x * speed

func gravity():
	if is_on_floor():
		velocity.y = 0
		airtime = 0
	else:
		velocity.y += gravity
		airtime += 1
		if Input.is_action_just_released("jump"):
			airtime = jumptime
			velocity.y = velocity.y/1.5
	
	if Input.is_action_pressed("jump") && airtime < jumptime:
			velocity.y -= jumpforce
	
func _physics_process(delta):
	get_input()
	gravity()
	move_and_slide(velocity, Vector2.UP)
