extends Control

@onready var sfx_click_button = get_node("/root/SoundEffects/SFX_ClickButton")

func _on_play_button_pressed():
	sfx_click_button.play()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")

func _on_exit_button_pressed():
	sfx_click_button.play()
	await get_tree().create_timer(.5).timeout
	get_tree().quit()
