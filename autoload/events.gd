extends Node

signal scale_up(node: Node2D)
signal scale_down(node: Node2D)


func emit_scale_up(node: Node2D):
	scale_up.emit(node)


func emit_scale_down(node: Node2D):
	scale_down.emit(node)
