extends CharacterBody2D

@onready var floor_ray = $FloorRay
@onready var wall_ray = $WallRay
@onready var timer = $Timer
var spawn_pos 
const SPEED = 150.0
var direction = 1
var bullet = preload("res://Units/bullet.tscn")

func _ready():
	spawn_pos = self.global_position
	flip()
	if !GameManager.is_alive:
		set_physics_process(false)
		await get_tree().create_timer(1.0).timeout
		set_physics_process(true)

func _physics_process(delta):
		if timer.time_left == 0.0:
			timer.start()
		if not is_on_floor():
			velocity.y += 1000 * delta
		velocity.x = SPEED * direction 
		if not floor_ray.is_colliding() or wall_ray.is_colliding():
			flip()
		move_and_slide()
func flip():
	direction *= -1
	floor_ray.position.x *= -1
	wall_ray.position.x *= -1
	wall_ray.target_position.x *= -1
	
func fire():
	var instance = bullet.instantiate()
	add_child(instance)
	instance.global_position = self.global_position
	instance.direction = self.direction
	


func _on_timer_timeout():
	fire()
	timer.start()





func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var level = get_tree().current_scene
		level.reset_level()
