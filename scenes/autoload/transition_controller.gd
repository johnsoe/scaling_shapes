extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Constraints/AnimationPlayer
@onready var black_box: TextureRect = $Constraints/BlackBox
@onready var flavor_text: Label = $Constraints/FlavorText

####################################################################################################
# Scene Loading Data                                                                               #
####################################################################################################
var music_map: Dictionary = {
								"main_menu": "title",
								"level_1": "graveyard",
								"level_2": "sewer",
								"level_3": "cave"
							}

var scene_map: Dictionary = {
								"main_menu": "res://scenes/main_menu.tscn",
								"level_1": "res://scenes/levels/l1_graveyard.tscn",
								"level_2": "res://scenes/levels/l2_sewer.tscn",
								"level_3": "res://scenes/levels/l3_cave.tscn"
							}

var flavor_text_map: Dictionary = {
									  "main_menu": "Main Menu",
									  "level_1": "Level 1:\nThe Growing Graveyard",
									  "level_2": "Level 2:\nSeattle's Scalable Sewers",
									  "level_3": "Level 3:\nCave of Condensing"
								  }

####################################################################################################
# Scene Transition Variables                                                                       #
####################################################################################################
var next_song: String
var next_scene: String


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


func transition_to_level(caller_size: Vector2, box_position: Vector2, target_level: String):

	# Set transition box transform
	black_box.set_position(box_position + caller_size / 2 - black_box.size / 2)

	# Set variables for transition
	next_song = music_map[target_level]
	next_scene = scene_map[target_level]
	flavor_text.text = flavor_text_map[target_level]

	# Fade out current scene
	MusicController.fade_out()
	animation_player.play("Fade Out Scene")


func reload_current_level(caller_size: Vector2, box_position: Vector2):

	# Set transition box transform
	black_box.set_position(box_position + caller_size / 2 - black_box.size / 2)

	# Fade out current scene
	MusicController.fade_out()
	animation_player.play("Fade Out Scene")


####################################################################################################
# Animation Signals                                                                                #
####################################################################################################
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade Out Scene":
		if next_scene != null:

			# Unpause the engine if needed
			if get_tree().paused:
				get_tree().paused = false

			# Load next scene
			if not next_song.is_empty():
				MusicController.load_song(next_song)
			if not next_scene.is_empty():
				get_tree().change_scene_to_file(next_scene)

			# Fade in new scene
			MusicController.fade_in()
			animation_player.play("Fade In Scene")
