extends Node2D

var toggle = 1

func _ready():
	pass

func _process(delta):
	
	if toggle:
		$Camera.global_position = lerp($Camera.global_position, $CameraTarget.global_position, 0.1)
		$CameraTarget.global_position = lerp($Player.global_position, get_global_mouse_position(), 0.25)

	if Input.is_action_just_pressed("balls"):
		toggle = !toggle
