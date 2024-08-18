extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Constraints/AnimationPlayer
@onready var black_box: TextureRect = $Constraints/BlackBox
@onready var flavor_text: Label = $Constraints/FlavorText

####################################################################################################
# Scene Loading Data                                                                               #
####################################################################################################
var music_map: Dictionary = {
								"main_menu": "title",
								"level_1": "cave",
								"level_2": "cave",
								"level_3": "cave",
								"level_4": "pharmacy"
							}

var scene_map: Dictionary = {
								"main_menu": "res://scenes/main_menu.tscn",
								"level_1": "res://scenes/levels/level_0.tscn",
								"level_2": "res://scenes/levels/level_0.tscn",
								"level_3": "res://scenes/levels/level_0.tscn",
								"level_4": "res://scenes/levels/level_0.tscn"
							}

var flavor_text_map: Dictionary = {
									  "main_menu": "Main Menu",
									  "level_1": "Level 1: The Graveyard",
									  "level_2": "Level 2: The Caves",
									  "level_3": "Level 3: The Sewers",
									  "level_4": "Level 4: The Pharmacy"
								  }

####################################################################################################
# Scene Transition Variables                                                                       #
####################################################################################################
var next_song  = music_map["main_menu"]
var next_scene = scene_map["main_menu"]


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


####################################################################################################
# Scene Transition Functions                                                                       #
####################################################################################################
func is_transitioning() -> bool:
	return animation_player.is_playing()


func get_remaining_transition_time() -> float:
	return animation_player.current_animation_length - animation_player.current_animation_position


func transition_to_level(box_size, box_position, box_rotation, target_level):

	# Set transition box transform
	black_box.size = box_size
	black_box.set_position(box_position)
	black_box.rotation_degrees = box_rotation

	# Set variables for transition
	next_song = music_map[target_level]
	next_scene = scene_map[target_level]
	flavor_text.text = flavor_text_map[target_level]

	# Fade out current scene
	MusicController.fade_out()
	animation_player.play("Fade Out Scene")


func reload_current_level(box_size, box_position, box_rotation):

	# Set transition box transform
	black_box.size = box_size
	black_box.set_position(box_position)
	black_box.rotation_degrees = box_rotation

	# Fade out current scene
	MusicController.fade_out()
	animation_player.play("Fade Out Scene")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade Out Scene":
		if next_scene != null:

			# Unpause the engine if needed
			if get_tree().paused:
				get_tree().paused = false

			# Load next scene
			MusicController.load_song(next_song)
			get_tree().change_scene_to_file(next_scene)

			# Fade in new scene
			MusicController.fade_in()
			animation_player.play("Fade In Scene")
