extends Node2D
class_name Cheekpoint

signal cheekpoint_entered(id: int, position: Vector2)

@export var cp_id: int

var is_active = false

# Only the player area_2d exists on the cheekpoint layer so this
# should only interact with that object
func _on_area_2d_area_entered(area):
	if not is_active:
		cheekpoint_entered.emit(cp_id, position)
		is_active = true
