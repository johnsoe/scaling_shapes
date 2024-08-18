extends Node

@onready var sfx_click_button: AudioStreamPlayer = $SFX_ClickButton
@onready var sfx_ghost_enter: AudioStreamPlayer = $SFX_GhostEnter
@onready var sfx_ghost_exit: AudioStreamPlayer = $SFX_GhostExit
@onready var sfx_level_complete: AudioStreamPlayer = $SFX_LevelComplete
@onready var sfx_pause_game: AudioStreamPlayer = $SFX_PauseGame
@onready var sfx_resume_game: AudioStreamPlayer = $SFX_ResumeGame
@onready var sfx_scale_down: AudioStreamPlayer = $SFX_ScaleDown
@onready var sfx_scale_up: AudioStreamPlayer = $SFX_ScaleUp


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_click_button():
	sfx_click_button.play()


func play_ghost_enter():
	sfx_ghost_enter.play()


func play_ghost_exit():
	sfx_ghost_exit.play()


func play_level_complete():
	sfx_level_complete.play()


func play_pause_game():
	sfx_pause_game.play()


func play_resume_game():
	sfx_resume_game.play()


func play_scale_down():
	sfx_scale_down.play()


func play_scale_up():
	sfx_scale_up.play()
