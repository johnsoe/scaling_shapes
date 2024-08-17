extends Control

@onready var sfx_click_button = get_node("/root/SoundEffects/SFX_ClickButton")

var window_size
var window_position

func _on_play_button_pressed():
	sfx_click_button.play()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")


func _on_exit_button_pressed():
	sfx_click_button.play()
	await get_tree().create_timer(.5).timeout
	get_tree().quit()


func _on_fullscreen_button_pressed():	
	sfx_click_button.play()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(window_size)
		DisplayServer.window_set_position(window_position)
	else:
		window_size = DisplayServer.window_get_size()
		window_position = DisplayServer.window_get_position()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
