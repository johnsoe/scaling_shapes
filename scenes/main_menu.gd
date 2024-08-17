extends Control

@onready var sfx_click_button = get_node("/root/SoundEffects/SFX_ClickButton")
@onready var menu_animation = $Animation/MenuAnimation
@onready var logo_animation = $Animation/LogoAnimation

var window_size
var window_position
var button_hover_sfx_enabled = false

####################################################################################################
# Custom Functions                                                                                 #
####################################################################################################
func button_press_shared():
	sfx_click_button.play()
	

func button_hover_shared():
	if button_hover_sfx_enabled:
		sfx_click_button.play()


####################################################################################################
# Animation Signals                                                                                #
####################################################################################################
func _on_logo_animation_animation_finished(anim_name):
	if anim_name == "Logo Intro":
		logo_animation.play("Logo Move")


func _on_menu_animation_animation_finished(anim_name):
	if anim_name == "Menu Intro":
		button_hover_sfx_enabled = true
		menu_animation.play("Menu Move")


####################################################################################################
# Button Press Signals                                                                             #
####################################################################################################
func _on_fullscreen_button_pressed():	
	button_press_shared()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(window_size)
		DisplayServer.window_set_position(window_position)
	else:
		window_size = DisplayServer.window_get_size()
		window_position = DisplayServer.window_get_position()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_exit_button_pressed():
	button_press_shared()
	await get_tree().create_timer(.3).timeout
	get_tree().quit()


func _on_level_1_button_pressed():
	button_press_shared()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")


func _on_level_2_button_pressed():
	button_press_shared()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")


func _on_level_3_button_pressed():
	button_press_shared()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")


func _on_level_4_button_pressed():
	button_press_shared()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")


func _on_level_5_button_pressed():
	button_press_shared()
	get_tree().change_scene_to_file("res://scenes/levels/level_0.tscn")


####################################################################################################
# Button Hover Signals                                                                             #
####################################################################################################
func _on_fullscreen_button_mouse_entered():
	button_hover_shared()


func _on_exit_button_mouse_entered():
	button_hover_shared()


func _on_level_1_button_mouse_entered():
	button_hover_shared()


func _on_level_2_button_mouse_entered():
	button_hover_shared()


func _on_level_3_button_mouse_entered():
	button_hover_shared()


func _on_level_4_button_mouse_entered():
	button_hover_shared()


func _on_level_5_button_mouse_entered():
	button_hover_shared()
