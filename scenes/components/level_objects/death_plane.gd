extends Area2D

const DEATH_BOX_POSITION: Vector2 = Vector2(960, 1280)


func _on_body_entered(body):
	if body.name == "PlayerNode":
		TransitionController.reload_current_level(Vector2.ZERO, DEATH_BOX_POSITION)
