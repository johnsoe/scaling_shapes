extends Node

@export var scale_max: float = 4.0
@export var scale_min: float = 0.4
@export var scale_increment: float = 0.02
@export var rb_2d: RigidBody2D
@export var collision_2d: CollisionShape2D
@export var animated_sprite: AnimatedSprite2D

var is_inhabited    = false
var current_scaling = 0.0


func _ready():
	Events.scale_up.connect(on_scale_up)
	Events.scale_down.connect(on_scale_down)
	Events.scale_pause.connect(on_scale_pause)
	Events.node_inhabited.connect(on_node_inhabited)
	Events.node_uninhabited.connect(on_node_uninhabited)
	if animated_sprite != null:
		animated_sprite.play("default")


func _physics_process(_delta):
	if not is_inhabited:
		return

	var updated_scale: Vector2 = Vector2(
									 clamp(animated_sprite.scale.x + current_scaling, scale_min, scale_max),
									 clamp(animated_sprite.scale.y + current_scaling, scale_min, scale_max),
								 )

	if animated_sprite.scale > updated_scale and not SFXController.is_scale_sfx_playing():
		SFXController.play_scale_down()
	elif animated_sprite.scale < updated_scale and not SFXController.is_scale_sfx_playing():
		SFXController.play_scale_up()

	rb_2d.mass = updated_scale.x
	collision_2d.scale = updated_scale
	animated_sprite.scale = updated_scale


func on_scale_up(node: RigidBody2D):
	if (rb_2d == node):
		animated_sprite.play("inflate")
		current_scaling = scale_increment


func on_scale_down(node: RigidBody2D):
	if (rb_2d == node):
		animated_sprite.play("deflate")
		current_scaling = scale_increment * -1


func on_scale_pause(node: RigidBody2D):
	if (rb_2d == node):
		animated_sprite.play("neutral")
		current_scaling = 0.0


func on_node_inhabited(node: RigidBody2D):
	if (rb_2d == node):
		animated_sprite.play("neutral")
		is_inhabited = true


func on_node_uninhabited(node: RigidBody2D):
	if (rb_2d == node):
		animated_sprite.play("default")
		is_inhabited = false
