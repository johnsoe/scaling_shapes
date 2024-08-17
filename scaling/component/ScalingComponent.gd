extends Node

@export var scaling_speed = 0.0
@export var scale_max = 4.0
@export var scale_min = 0.4
@export var scale_increment = 0.2
@export var node_to_scale: Node2D

func _ready():
	Events.scale_up.connect(on_scale_up)
	Events.scale_down.connect(on_scale_down)


func on_scale_up(node: Node2D):
	if (node_to_scale == node):
		scale_helper(scale_increment)
		

func on_scale_down(node: Node2D):
	if (node_to_scale == node):
		scale_helper(scale_increment * -1)


func scale_helper(delta):
	var scale = node_to_scale.scale
	var updated_scale = Vector2(
		clamp(scale.x + delta, scale_min, scale_max),
		clamp(scale.y + delta, scale_min, scale_max)
	)
	node_to_scale.scale = updated_scale
