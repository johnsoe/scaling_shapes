extends Node

@export var scaling_speed = 0.0
@export var scale_max = 4.0
@export var scale_min = 0.4
@export var scale_increment = 0.02

@export var rb_2d: RigidBody2D
@export var collision_2d: CollisionShape2D
@export var sprite_2d: Sprite2D

func _ready():
	Events.scale_up.connect(on_scale_up)
	Events.scale_down.connect(on_scale_down)


func on_scale_up(node: RigidBody2D):
	if (rb_2d == node):
		scale_helper(scale_increment)
		

func on_scale_down(node: RigidBody2D):
	if (rb_2d == node):
		scale_helper(scale_increment * -1)


func scale_helper(delta):
	
	var updated_scale = Vector2(
		clamp(sprite_2d.scale.x + delta, scale_min, scale_max),
		clamp(sprite_2d.scale.y + delta, scale_min, scale_max),
	)
	rb_2d.mass = updated_scale.x
	collision_2d.scale = updated_scale
	sprite_2d.scale = updated_scale
	
