extends Node

@export var level_name: String
@export var player_node: Node2D

const CHEEKPOINT_FILE: String = "user://cheekpoint.dat"

var id_key: String 
var position_x_key: String 
var position_y_key: String 

var cheekpoint_dict = {}

func _ready():
	id_key = str(level_name, "_id")
	position_x_key = str(level_name, "_position_x")
	position_y_key = str(level_name, "_position_y")
	
	load_cheekpoint_state()
	if player_node != null and cheekpoint_dict.has(position_x_key):
		var x = cheekpoint_dict[position_x_key] as int
		var y = cheekpoint_dict[position_y_key] as int
		player_node.position = Vector2(x, y)
		
	for child in get_children():
		if child is Cheekpoint:
			child.cheekpoint_entered.connect(on_cheekpoint_entered)
			

func _exit_tree():
	save_cheekpoint_state()


func on_cheekpoint_entered(id: int, position: Vector2):
	if not cheekpoint_dict.has(id_key) or cheekpoint_dict[id_key] < id:
		cheekpoint_dict[position_x_key] = position.x
		cheekpoint_dict[position_y_key] = position.y
		cheekpoint_dict[id_key] = id


func save_cheekpoint_state():
	var file = FileAccess.open(CHEEKPOINT_FILE, FileAccess.WRITE)
	var json_str = JSON.stringify(cheekpoint_dict)
	file.store_line(json_str)
	file.close()


func load_cheekpoint_state():
	var file = FileAccess.open(CHEEKPOINT_FILE, FileAccess.READ)
	if not file or file == null:
		return
	if not FileAccess.file_exists(CHEEKPOINT_FILE):
		return
#
	cheekpoint_dict = JSON.parse_string(file.get_line())
	file.close()


func _on_level_goal_level_complete():
	cheekpoint_dict.erase(id_key)
	cheekpoint_dict.erase(position_x_key)
	cheekpoint_dict.erase(position_y_key)
