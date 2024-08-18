extends CanvasLayer

@onready var music_controller = get_node("/root/MusicController")
@onready var sfx_controller = get_node("/root/SFXController")
@onready var transition_controller = get_node("/root/TransitionController")

@onready var hud = $Constraints/Hud
@onready var pause_menu = $Constraints/PauseMenu
@onready var restart_level_button = $Constraints/PauseMenu/RestartLevelButton
@onready var main_menu_button = $Constraints/PauseMenu/MainMenuButton

####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


####################################################################################################
# Custom Functions                                                                                 #
####################################################################################################
func button_hover_shared():
	sfx_controller.play_click_button()


####################################################################################################
# Button Press Signals                                                                             #
####################################################################################################
func _on_pause_button_pressed():
	sfx_controller.play_click_button()
	
	music_controller.muffle()
	hud.visible = false
	pause_menu.visible = true
	get_tree().paused = true


func _on_resume_button_pressed():
	sfx_controller.play_click_button()
	
	music_controller.reset_muffle()
	hud.visible = true
	pause_menu.visible = false
	get_tree().paused = false


func _on_restart_level_button_pressed():
	sfx_controller.play_click_button()
	
	music_controller.reset_muffle()
	get_tree().paused = false
	transition_controller.reload_current_level(
		restart_level_button.size,
		restart_level_button.position,
		restart_level_button.rotation_degrees
	)


func _on_main_menu_button_pressed():
	sfx_controller.play_click_button()
	
	music_controller.reset_muffle()
	get_tree().paused = false
	transition_controller.transition_to_level(
		main_menu_button.size,
		main_menu_button.position,
		main_menu_button.rotation_degrees,
		"main_menu"
	)


####################################################################################################
# Button Hover Signals                                                                             #
####################################################################################################
func _on_pause_button_mouse_entered():
	button_hover_shared()


func _on_resume_button_mouse_entered():
	button_hover_shared()


func _on_restart_level_button_mouse_entered():
	button_hover_shared()


func _on_main_menu_button_mouse_entered():
	button_hover_shared()
