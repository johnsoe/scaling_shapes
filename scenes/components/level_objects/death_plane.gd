extends Area2D

const DEATH_BOX_SIZE: Vector2 = Vector2(200, 200)


func _on_body_entered(body):
    if body.name == "PlayerNode":
        TransitionController.reload_current_level(
            DEATH_BOX_SIZE,
            body.position,
            body.rotation_degrees
        )
