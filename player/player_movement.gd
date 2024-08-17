extends CharacterBody2D

@export var speed = 400
@export var jump_speed = -400

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func get_input():
	var input_direction = Input.get_axis("left", "right")
	if input_direction:
		velocity.x = input_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	get_input()
	move_and_slide()
