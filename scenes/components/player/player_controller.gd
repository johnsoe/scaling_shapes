extends CharacterBody2D

signal inhabit_node(node: RigidBody2D)
signal uninhabit_node()
@export var speed: int = 500
@export var jump_speed: int = -1000
@export var gravity_scale: float = 1.5
@export var push_force: float = 20
@export var uninhabit_offset: Vector2 = Vector2(0, -100)

@onready var scaling_manager: ScalingManager = $ScalingManager
@onready var collision2d: CollisionShape2D = $CollisionShape2D
@onready var area2d: Area2D = $Area2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

var nearbyObjects: Array[Variant] = []
var gravity                       = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_has_moved_left: bool   = false
var player_has_moved_right: bool  = false
var player_has_inhabit: bool      = false
var player_has_uninhabit: bool    = false


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	if not TutorialController.tutorial_complete:
		TutorialController.start_tutorial()


func _process(_delta):
	if not TutorialController.tutorial_complete:
		TutorialController.set_tutorial_position(position)

		if player_has_moved_left and player_has_moved_right:
			TutorialController.complete_step_move()

		if player_has_inhabit and player_has_uninhabit:
			TutorialController.complete_step_possess()


func _input(event):
	if event.is_action_pressed("inhabit"):
		if scaling_manager.is_inhabited():
			on_uninhabit()
		elif not nearbyObjects.is_empty():
			on_inhabit()


func _physics_process(delta):
	if scaling_manager.is_inhabited():
		position = scaling_manager.inhabited_node.position
		return

	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		SFXController.play_jump()
		velocity.y = jump_speed

		if not TutorialController.tutorial_complete:
			TutorialController.complete_step_jump()

	var was_on_floor: bool = is_on_floor()
	get_input()
	move_and_slide()
	if was_on_floor and !is_on_floor():
		coyote_timer.start()

	if not was_on_floor and is_on_floor():
		SFXController.play_jump_land()

	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * push_force)


####################################################################################################
# Input Functions                                                                                  #
####################################################################################################
func get_input():
	var input_direction: float = Input.get_axis("left", "right")

	if input_direction > 0:
		animated_sprite.flip_h = false
		if not TutorialController.tutorial_complete:
			player_has_moved_left = true

	elif input_direction < 0:
		animated_sprite.flip_h = true
		if not TutorialController.tutorial_complete:
			player_has_moved_right = true

	if input_direction:
		velocity.x = input_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func on_inhabit():
	SFXController.play_ghost_enter()
	visible = false
	inhabit_node.emit(nearbyObjects.back())
	Events.emit_node_unselected(nearbyObjects.back())

	if not TutorialController.tutorial_complete:
		player_has_inhabit = true


func on_uninhabit():
	SFXController.play_ghost_exit()
	position = scaling_manager.inhabited_node.position + uninhabit_offset
	visible = true
	uninhabit_node.emit()
	if not nearbyObjects.is_empty():
		Events.emit_node_selected(nearbyObjects.back())

	if not TutorialController.tutorial_complete:
		player_has_uninhabit = true


####################################################################################################
# Collision Signals                                                                                #
####################################################################################################
# Area entered signal from area2d
func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("habitable_objects") and not nearbyObjects.has(body) and body is RigidBody2D:
		nearbyObjects.append(body as RigidBody2D)
		if not scaling_manager.is_inhabited():
			Events.emit_node_selected(body)


# Area exited signal from area2d
func _on_area_2d_body_exited(body: Node2D):
	if body == scaling_manager.inhabited_node:
		return

	if body.is_in_group("habitable_objects") and nearbyObjects.has(body):
		nearbyObjects.erase(body)
		Events.emit_node_unselected(body)
		if not nearbyObjects.is_empty():
			Events.emit_node_selected(nearbyObjects.back())
