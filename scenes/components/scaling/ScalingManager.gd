extends Node
class_name ScalingManager

var inhabited_node: RigidBody2D = null


func is_inhabited() -> bool:
	return inhabited_node != null


func _input(_delta):
	if Input.is_action_pressed("up") and is_inhabited():
		Events.emit_scale_up(inhabited_node)
	elif Input.is_action_pressed("down") and is_inhabited():
		Events.emit_scale_down(inhabited_node)
	elif Input.is_action_just_released("down") or Input.is_action_just_released("up"):
		Events.emit_scale_pause(inhabited_node)


func _on_player_node_inhabit_node(node):
	Events.emit_node_inhabited(node)
	inhabited_node = node


func _on_player_node_uninhabit_node():
	Events.emit_scale_pause(inhabited_node)
	Events.emit_node_uninhabited(inhabited_node)
	inhabited_node = null
