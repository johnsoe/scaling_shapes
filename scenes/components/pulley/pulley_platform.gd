extends AnimatableBody2D

signal mass_updated(mass: float)

@export var difference_threshold = 0.5
@onready var area_2d: Area2D = $Area2D

var last_mass = 0.0
var rb2d_in_area: Array[RigidBody2D] = []


func _physics_process(delta):
	var total_mass = 0.0
	for rb2d in rb2d_in_area:
		total_mass += rb2d.mass
	
	if abs(total_mass - last_mass) > difference_threshold:
		mass_updated.emit(total_mass)
		last_mass = total_mass

func _on_area_2d_body_entered(body):
	# Does the player have mass?
	if body is RigidBody2D and body not in rb2d_in_area:
		rb2d_in_area.append(body)


func _on_area_2d_body_exited(body):
	if body in rb2d_in_area:
		rb2d_in_area.erase(body)
