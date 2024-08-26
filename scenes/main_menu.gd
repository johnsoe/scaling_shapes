extends Control

@onready var menu_animation: AnimationPlayer = $Animation/MenuAnimation
@onready var logo_animation: AnimationPlayer = $Animation/LogoAnimation
@onready var level_1_button: TextureButton = $Buttons/Level1Button
@onready var level_2_button: TextureButton = $Buttons/Level2Button
@onready var level_3_button: TextureButton = $Buttons/Level3Button
@onready var level_1_best_time: Label = $Buttons/Level1Button/Level1BestTime
@onready var level_2_best_time: Label = $Buttons/Level2Button/Level2BestTime
@onready var level_3_best_time: Label = $Buttons/Level3Button/Level3BestTime

var window_size: Vector2i
var window_position: Vector2i
var buttons_active: bool = false


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():

	# Disable HUD and level timer, these aren't needed in the main menu
	HudController.disable_hud()
	TimeTrialController.stop_timer()

	# Load level time data
	level_1_best_time.text = "Best Time: %s" % TimeTrialController.get_timestamp(TimeTrialController.level_1_best_time)
	level_2_best_time.text = "Best Time: %s" % TimeTrialController.get_timestamp(TimeTrialController.level_2_best_time)
	level_3_best_time.text = "Best Time: %s" % TimeTrialController.get_timestamp(TimeTrialController.level_3_best_time)

	# If transitioning to the main menu, wait for the transition to finish before playing intro
	if TransitionController.is_transitioning():
		var wait_time: float = TransitionController.get_remaining_transition_time()
		await get_tree().create_timer(wait_time + .2).timeout

	# Play main menu intro
	menu_animation.play("Menu Intro")
	logo_animation.play("Logo Intro")
	MusicController.load_song("title")
	MusicController.fade_in()


####################################################################################################
# Custom Functions                                                                                 #
####################################################################################################
func button_hover_shared():
	if not buttons_active:
		return

	SFXController.play_click_button()


func transition_to_level(level_button: TextureButton):
	if not buttons_active:
		return

	var target_level: String = "main_menu"
	if level_button == level_1_button:
		target_level = "level_1"
	elif level_button == level_2_button:
		target_level = "level_2"
	elif level_button == level_3_button:
		target_level = "level_3"

	buttons_active = false
	SFXController.play_click_button()
	TransitionController.transition_to_level(level_button.size, level_button.position, target_level)


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

	SFXController.play_click_button()
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

	SFXController.play_click_button()
	await get_tree().create_timer(.3).timeout
	get_tree().quit()


func _on_level_1_button_pressed():
	transition_to_level(level_1_button)


func _on_level_2_button_pressed():
	transition_to_level(level_2_button)


func _on_level_3_button_pressed():
	transition_to_level(level_3_button)


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

