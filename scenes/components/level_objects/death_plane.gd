extends Area2D

const DEATH_BOX_SIZE: Vector2     = Vector2(200, 200)
const DEATH_BOX_POSITION: Vector2 = Vector2(1920 / 2, 1080 + 200)
const DEATH_BOX_ROTATION: float   = 0


func _on_body_entered(body):
	if body.name == "PlayerNode":
		TransitionController.reload_current_level(
			DEATH_BOX_SIZE,
			DEATH_BOX_POSITION,
			DEATH_BOX_ROTATION
		)
