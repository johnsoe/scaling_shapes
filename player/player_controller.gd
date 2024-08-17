extends CharacterBody2D

signal inhabit_node(node: Node2D)
signal uninhabit_node()

@export var speed = 400
@export var jump_speed = -400

@onready var scaling_manager: ScalingManager = $ScalingManager

var nearbyObjects = []
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action_pressed("inhabit"):
		if scaling_manager.is_inhabited():
			on_uninhabit()
		elif not nearbyObjects.is_empty():
			on_inhabit()

func get_input():
	var input_direction = Input.get_axis("left", "right")
	if input_direction:
		velocity.x = input_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func _physics_process(delta):
	if scaling_manager.is_inhabited():
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		
	get_input()
	move_and_slide()


# Area entered signal from area2d
func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("habitable_objects") and not nearbyObjects.has(body):
		nearbyObjects.append(body)

# Area exited signal from area2d
func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("habitable_objects") and nearbyObjects.has(body):
		nearbyObjects.erase(body)
		


func on_inhabit():
	inhabit_node.emit(nearbyObjects.back())
	


func on_uninhabit():
	uninhabit_node.emit()
