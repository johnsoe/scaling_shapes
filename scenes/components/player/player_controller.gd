extends CharacterBody2D

signal inhabit_node(node: RigidBody2D)
signal uninhabit_node()

@export var speed = 400
@export var jump_speed = -400

@onready var scaling_manager: ScalingManager = $ScalingManager
@onready var collision2d = $CollisionShape2D
@onready var area2d = $Area2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var coyote_timer = $CoyoteTimer

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
	
	if input_direction > 0:
		animated_sprite.flip_h = false
	elif input_direction < 0:
		animated_sprite.flip_h = true
	
	if input_direction:
		velocity.x = input_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func _physics_process(delta):
	if scaling_manager.is_inhabited():
		var rb2d = scaling_manager.inhabited_node
		if area2d.overlaps_body(rb2d):
			velocity.y = jump_speed
		else:
			velocity.y = 0
		velocity.x = 0
		move_and_slide()
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = jump_speed
	
	var was_on_floor = is_on_floor()
	get_input()
	move_and_slide()
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	


# Area entered signal from area2d
func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("habitable_objects") and not nearbyObjects.has(body) and body is RigidBody2D:
		nearbyObjects.append(body as RigidBody2D)


# Area exited signal from area2d
func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("habitable_objects") and nearbyObjects.has(body):
		nearbyObjects.erase(body)
		


func on_inhabit():
	collision2d.set_deferred("disabled", true)
	hide()
	inhabit_node.emit(nearbyObjects.back())
	

func on_uninhabit():
	collision2d.set_deferred("disabled", false)
	show()
	uninhabit_node.emit()
