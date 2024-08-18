extends Node

signal scale_up(node: RigidBody2D)
signal scale_down(node: RigidBody2D)


func emit_scale_up(node: RigidBody2D):
	scale_up.emit(node)


func emit_scale_down(node: RigidBody2D):
	scale_down.emit(node)
