extends CanvasLayer

@onready var music_controller = get_node("/root/MusicController")

@onready var animation_player = $Constraints/AnimationPlayer
@onready var black_box = $Constraints/BlackBox
@onready var flavor_text = $Constraints/FlavorText

####################################################################################################
# Scene Loading Data                                                                               #
####################################################################################################
var music_map = {
	"main_menu": "title",
	"level_1": "cave",
	"level_2": "cave",
	"level_3": "cave",
	"level_4": "cave",
	"level_5": "cave"
}
var scene_map = {
	"main_menu": "res://scenes/main_menu.tscn",
	"level_1": "res://scenes/levels/level_0.tscn",
	"level_2": "res://scenes/levels/level_0.tscn",
	"level_3": "res://scenes/levels/level_0.tscn",
	"level_4": "res://scenes/levels/level_0.tscn",
	"level_5": "res://scenes/levels/level_0.tscn"
}
var flavor_text_map = {
	"main_menu": "Main Menu",
	"level_1": "Level 1: The Graveyard",
	"level_2": "Level 2: The Caves",
	"level_3": "Level 3: The Forest",
	"level_4": "Level 4: The Sewers",
	"level_5": "Level 5: The Pharmacy"
}


####################################################################################################
# Scene Transition Variables                                                                       #
####################################################################################################
var next_song = music_map["main_menu"]
var next_scene = scene_map["main_menu"]


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


####################################################################################################
# Scene Transition Functions                                                                       #
####################################################################################################
func is_transitioning():
	return animation_player.is_playing()


func get_remaining_transition_time():
	return animation_player.current_animation_length - animation_player.current_animation_position


func transition_to_level(box_size, box_postition, box_rotation, target_level):
	
	# Set transition box transform
	black_box.size = box_size
	black_box.set_position(box_postition)
	black_box.rotation_degrees = box_rotation
	
	# Set variables for transition
	next_song = music_map[target_level]
	next_scene = scene_map[target_level]
	flavor_text.text = flavor_text_map[target_level]
	
	# Fade out current scene
	music_controller.fade_out()
	animation_player.play("Fade Out Scene")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade Out Scene":
		if next_scene != null:
			
			# Load next scene
			music_controller.load_song(next_song)
			get_tree().change_scene_to_file(next_scene)
			
			# Fade in new scene
			music_controller.fade_in()
			animation_player.play("Fade In Scene")
