extends Node

signal scale_up(node: RigidBody2D)
signal scale_down(node: RigidBody2D)
signal scale_pause(node: RigidBody2D)
signal node_inhabited(node: RigidBody2D)
signal node_uninhabited(node: RigidBody2D)
signal node_selected(node: RigidBody2D)
signal node_unselected(node: RigidBody2D)


func emit_scale_up(node: RigidBody2D):
	scale_up.emit(node)


func emit_scale_down(node: RigidBody2D):
	scale_down.emit(node)


func emit_scale_pause(node: RigidBody2D):
	scale_pause.emit(node)


func emit_node_inhabited(node: RigidBody2D):
	node_inhabited.emit(node)


func emit_node_uninhabited(node: RigidBody2D):
	node_uninhabited.emit(node)
	

func emit_node_selected(node: RigidBody2D):
	node_selected.emit(node)


func emit_node_unselected(node: RigidBody2D):
	node_unselected.emit(node)
