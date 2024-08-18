extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func load_song(target_song):
	music_player.playing = false
	music_player.stream = load("res://assets/music/%s.ogg" % target_song)


func fade_in():
	music_player.playing = true
	animation_player.play("Fade In")


func fade_out():
	animation_player.play("Fade Out")


func muffle():
	music_player.bus = "Muffle"


func reset_muffle():
	music_player.bus = "Master"


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade Out":
		music_player.playing = false
