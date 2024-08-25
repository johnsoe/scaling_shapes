extends Control

const WANDER_SPEED: float        = 100.0
const WANDER_WAIT_TIME: float    = 2.0
const WANDER_TARGET_MIN: Vector2 = Vector2(-100, 800)
const WANDER_TARGET_MAX: Vector2 = Vector2(2050, 950)
@onready var version_label: Label = $VersionLabel
@onready var menu_animation: AnimationPlayer = $Animation/MenuAnimation
@onready var logo_animation: AnimationPlayer = $Animation/LogoAnimation
@onready var cheek_a_boo: Node2D = $Animation/CheekABoo
@onready var cheek_a_boo_sprite: AnimatedSprite2D = $Animation/CheekABoo/CheekABooSprite
@onready var level_1_button: TextureButton = $Buttons/Level1Button
@onready var level_2_button: TextureButton = $Buttons/Level2Button
@onready var level_3_button: TextureButton = $Buttons/Level3Button
@onready var level_1_best_time: Label = $Buttons/Level1Button/Level1BestTime
@onready var level_2_best_time: Label = $Buttons/Level2Button/Level2BestTime
@onready var level_3_best_time: Label = $Buttons/Level3Button/Level3BestTime

var window_size: Vector2i
var window_position: Vector2i
var buttons_active: bool   = false
var start_wander: bool     = false
var wander_target: Vector2 = WANDER_TARGET_MIN
var wander_wait: float     = 0.0


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():

	# Disable HUD and level timer, these aren't needed in the main menu
	HudController.disable_hud()
	TimeTrialController.stop_timer()

	# Set game version string
	version_label.text = "Version %s" % ProjectSettings.get_setting("application/config/version")

	# Load level time data
	level_1_best_time.text = "Best Time: %s" % TimeTrialController.get_timestamp(TimeTrialController.level_1_best_time)
	level_2_best_time.text = "Best Time: %s" % TimeTrialController.get_timestamp(TimeTrialController.level_2_best_time)
	level_3_best_time.text = "Best Time: %s" % TimeTrialController.get_timestamp(TimeTrialController.level_3_best_time)

	# Move Cheek-A-Boo to wander starting point
	cheek_a_boo.position = WANDER_TARGET_MIN

	# If transitioning to the main menu, wait for the transition to finish before playing intro
	if TransitionController.is_transitioning():
		var wait_time: float = TransitionController.get_remaining_transition_time()
		await get_tree().create_timer(wait_time + .2).timeout

	# Play main menu intro
	menu_animation.play("Menu Intro")
	logo_animation.play("Logo Intro")
	MusicController.load_song("title")
	MusicController.fade_in()


func _process(delta):
	cheek_a_boo_wander(delta)


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


func cheek_a_boo_wander(delta):
	if not start_wander:
		return

	if cheek_a_boo.position == wander_target:

		# Wait at the target for a few seconds
		if wander_wait < WANDER_WAIT_TIME:
			wander_wait += delta
			return

		# Reset wait counter
		wander_wait = 0

		# Find a new target to wander to
		var wander_x = randf_range(WANDER_TARGET_MIN.x, WANDER_TARGET_MAX.x)
		var wander_y = randf_range(WANDER_TARGET_MIN.y, WANDER_TARGET_MAX.y)
		wander_target = Vector2(wander_x, wander_y)

		# Flip sprite if needed
		if wander_target > cheek_a_boo.position:
			cheek_a_boo_sprite.flip_h = false
		else:
			cheek_a_boo_sprite.flip_h = true

	# Wander to target
	cheek_a_boo.position = cheek_a_boo.position.move_toward(wander_target, delta * WANDER_SPEED)


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
		start_wander = true


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

