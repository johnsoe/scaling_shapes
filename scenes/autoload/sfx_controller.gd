extends Node

@onready var sfx_click_button = $SFX_ClickButton
@onready var sfx_ghost_enter = $SFX_GhostEnter
@onready var sfx_ghost_exit = $SFX_GhostExit
@onready var sfx_level_complete = $SFX_LevelComplete
@onready var sfx_pause_game = $SFX_PauseGame
@onready var sfx_resume_game = $SFX_ResumeGame
@onready var sfx_scale_down = $SFX_ScaleDown
@onready var sfx_scale_up = $SFX_ScaleUp

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
