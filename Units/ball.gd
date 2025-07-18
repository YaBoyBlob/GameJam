extends RigidBody2D

@onready var sprite_2d = $Sprite2D
var moving = false
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	
	var velocity = state.linear_velocity
	if velocity.length() <= 25.0 :
		moving = false
	else:
		moving = true
	#velocity.y += 1000 * state.step
	if velocity.x:
		velocity.x *= 0.995
	
	#sprite_2d.rotate(velocity.x/ 750.0)
	state.linear_velocity = velocity
	print(velocity.length())

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Enemy") and moving:
		area.get_parent().queue_free()
