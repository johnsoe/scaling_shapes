extends Node2D

@export var move_speed: float = 0.5
@export var wheel_rotation_fraction: float = 5.0
@export var max_offset: float = 50.0

@onready var platform_left: AnimatableBody2D = $PlatformControl/PulleyPlatformLeft
@onready var platform_right: AnimatableBody2D = $PlatformControl/PulleyPlatformRight
@onready var top_rope: Node2D = %TotalRope
@onready var wheel_left: Node2D = %PulleyWheelLeft
@onready var wheel_right: Node2D = %PulleyWheelRight

var left_mass: float       = 0.0
var right_mass: float      = 0.0
var init_y_position: float = 0.0


func _ready():
	#platform_left.sync_to_physics = true
	#platform_right.sync_to_physics = true

	init_y_position = platform_right.position.y


func _physics_process(_delta):
	var differential: float    = left_mass - right_mass
	var left_v: float          = differential * move_speed
	var right_updated: Vector2 = platform_right.position + Vector2(0, -left_v)

	# Pulley will extend past max position, do not go any further.
	if abs(init_y_position - right_updated.y) > max_offset:
		return

	platform_left.position += Vector2(0, left_v)
	platform_right.position = right_updated
	top_rope.position += Vector2(-left_v, 0)

	wheel_left.rotate(-left_v / PI / wheel_rotation_fraction)
	wheel_right.rotate(-left_v / PI / wheel_rotation_fraction)


func _on_pulley_platform_left_mass_updated(mass):
	left_mass = mass


func _on_pulley_platform_right_mass_updated(mass):
	right_mass = mass
