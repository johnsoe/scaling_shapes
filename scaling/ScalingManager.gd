extends Node
class_name ScalingManager

var inhabited_node: Node2D = null

func is_inhabited(): 
	return inhabited_node != null

func _process(_delta):
	if Input.is_action_pressed("up") and is_inhabited():
		Events.emit_scale_up(inhabited_node)
	elif Input.is_action_pressed("down") and is_inhabited():
		Events.emit_scale_down(inhabited_node)
		

func _on_player_node_inhabit_node(node):
	inhabited_node = node


func _on_player_node_uninhabit_node():
	inhabited_node = null

