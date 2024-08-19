extends Area2D

const GOAL_BOX_POSITION: Vector2 = Vector2(960, 540)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


####################################################################################################
# Level Goal Signals                                                                               #
####################################################################################################
func _on_body_entered(body):
	if body.name == "PlayerNode":
		SFXController.play_level_complete()
		body.visible = false
		label.visible = false
		get_tree().paused = true
		animated_sprite_2d.play("level complete")
		


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "level complete":
		TransitionController.transition_to_level(Vector2.ZERO, GOAL_BOX_POSITION, "main_menu")
