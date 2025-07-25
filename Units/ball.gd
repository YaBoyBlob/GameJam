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

func _ready():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	freeze = true  # this prevents it from reacting to physics
	await get_tree().create_timer(0.01).timeout  # wait 1 second
	unfreeze()

func unfreeze():
	freeze = false
	linear_velocity = Vector2.ZERO  # Prevent weird leftover movement

func vanish():
	collision_layer = 0
	collision_mask = 0
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC

	$AnimationPlayer.play("Vanish")
func exit():
	var level = get_tree().current_scene
	level.objects -=1
	queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("Wall"):
		vanish()
		


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Enemy") and moving:
		area.get_parent().queue_free()
	if area.get_parent().is_in_group("Boss"):
		area.get_parent().hit()
		vanish()
