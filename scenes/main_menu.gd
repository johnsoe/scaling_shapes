extends Control

@onready var music_controller = get_node("/root/MusicController")
@onready var sfx_controller = get_node("/root/SFXController")
@onready var transition_controller = get_node("/root/TransitionController")

@onready var menu_animation = $Animation/MenuAnimation
@onready var logo_animation = $Animation/LogoAnimation
@onready var level_1_button = $Buttons/Level1Button
@onready var level_2_button = $Buttons/Level2Button
@onready var level_3_button = $Buttons/Level3Button
@onready var level_4_button = $Buttons/Level4Button
@onready var level_5_button = $Buttons/Level5Button

var window_size
var window_position
var buttons_active = false

####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	music_controller.load_song("title")
	music_controller.fade_in()


####################################################################################################
# Custom Functions                                                                                 #
####################################################################################################
func button_hover_shared():
	if not buttons_active:
		return
	
	sfx_controller.play_click_button()


func transition_to_level(level_button: TextureButton):
	if not buttons_active:
		return
	
	var target_level = "main_menu"
	if level_button == level_1_button:
		target_level = "level_1"
	elif level_button == level_2_button:
		target_level = "level_2"
	elif level_button == level_3_button:
		target_level = "level_3"
	elif level_button == level_4_button:
		target_level = "level_4"
	elif level_button == level_5_button:
		target_level = "level_5"
	
	buttons_active = false
	sfx_controller.play_click_button()
	transition_controller.transition_to_level(
		level_button.position,
		level_button.rotation_degrees,
		target_level
	)


####################################################################################################
# Animation Signals                                                                                #
####################################################################################################
func _on_logo_animation_animation_finished(anim_name):
	if anim_name == "Logo Intro":
		logo_animation.play("Logo Move")


func _on_menu_animation_animation_finished(anim_name):
	if anim_name == "Menu Intro":
		buttons_active = true
		menu_animation.play("Menu Move")


####################################################################################################
# Button Press Signals                                                                             #
####################################################################################################
func _on_fullscreen_button_pressed():
	if not buttons_active:
		return
		
	sfx_controller.play_click_button()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(window_size)
		DisplayServer.window_set_position(window_position)
	else:
		window_size = DisplayServer.window_get_size()
		window_position = DisplayServer.window_get_position()
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_exit_button_pressed():
	if not buttons_active:
		return
		
	sfx_controller.play_click_button()
	await get_tree().create_timer(.3).timeout
	get_tree().quit()


func _on_level_1_button_pressed():
	transition_to_level(level_1_button)


func _on_level_2_button_pressed():
	transition_to_level(level_2_button)


func _on_level_3_button_pressed():
	transition_to_level(level_3_button)


func _on_level_4_button_pressed():
	transition_to_level(level_4_button)


func _on_level_5_button_pressed():
	transition_to_level(level_5_button)


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
