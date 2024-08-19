extends Node2D

const TUTORIAL_BUFFER: Vector2 = Vector2(0, -100)
@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
####################################################################################################
# Tutorial Data                                                                                    #
####################################################################################################
enum tutorial_step {
	move,
	jump,
	possess,
	scale_up,
	scale_down
}

var tutorial_messages: Array[String] = [
									   "Press [A] to move left\nPress [D] to move right",
									   "Press [Space] to jump",
									   "Press [R] to possess an object\nPress [R] to leave the object",
									   "While possessing an object:\nPress [W] to increase it's scale",
									   "While possessing an object:\nPress [S] to decrease it's scale"
									   ]

var tutorial_complete: bool              = false
var tutorial_current_step: tutorial_step = tutorial_step.move


####################################################################################################
# Built-In Functions                                                                               #
####################################################################################################
func _process(_delta):
	if tutorial_complete:
		return

	if label.text != tutorial_messages[tutorial_current_step]:
		label.text = tutorial_messages[tutorial_current_step]


####################################################################################################
# Tutorial Control Functions                                                                       #
####################################################################################################
func set_tutorial_position(tutorial_position: Vector2):
	position = tutorial_position + TUTORIAL_BUFFER


func start_tutorial():
	tutorial_complete = false
	tutorial_current_step = tutorial_step.move
	animation_player.play("Fade In")
	visible = true


func complete_step_move():
	if tutorial_current_step == tutorial_step.move:
		animation_player.play("Fade Out")


func complete_step_jump():
	if tutorial_current_step == tutorial_step.jump:
		animation_player.play("Fade Out")


func complete_step_possess():
	if tutorial_current_step == tutorial_step.possess:
		animation_player.play("Fade Out")


func complete_step_scale_up():
	if tutorial_current_step == tutorial_step.scale_up:
		animation_player.play("Fade Out")


func complete_step_scale_down():
	if tutorial_current_step == tutorial_step.scale_down:
		animation_player.play("Fade Out")


####################################################################################################
# Animation Signals                                                                                #
####################################################################################################
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Fade Out":
		if tutorial_current_step == tutorial_step.scale_down:
			tutorial_complete = true
			visible = false
			return

		tutorial_current_step += 1
		animation_player.play("Fade In")
