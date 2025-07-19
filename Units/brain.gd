extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer
@onready var stagger_timer = $StaggerTimer
@onready var animation_player = $AnimationPlayer
@onready var throw_pos = $ThrowPos
@onready var barrier = $Barrier
@onready var sprite_2d = $Sprite2D
@onready var health_bar = $HealthBar

@export var is_attacking: bool = false
var attack_queue: Array = []

var hp = 3
var barrier_active = true
var attack_interval = 1.0
var player_previous_pos: Vector2
var brain_projectile = preload("res://Units/brain_projectile.tscn")

enum state {
	Idle,
	Dash,
	Throw,
	Vein
}

# Only these are used for regular attack timer
var combat_states = [state.Dash, state.Throw]


func _ready():
	randomize()
	if !GameManager.is_alive:
		set_physics_process(false)
		await get_tree().create_timer(1.0).timeout
		set_physics_process(true)

func _physics_process(delta):
	# Start stagger timer if stopped
	if stagger_timer.is_stopped():
		stagger_timer.start(15)

	# Handle attack queue if not already attacking
	if !is_attacking and attack_queue.size() > 0:
		var next_attack = attack_queue.pop_front()
		start_attack(next_attack)

	# If idle and nothing queued, schedule next regular attack
	if !is_attacking and attack_queue.is_empty() and attack_timer.is_stopped():
		attack_interval = randf_range(2, 3.5)
		print(attack_interval)
		attack_timer.start(attack_interval)

	# Play Idle animation if doing nothing
	if !is_attacking and attack_queue.is_empty():
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")

func _on_timer_timeout():
	var random_state = combat_states.pick_random()
	attack_queue.append(random_state)

func _on_stagger_timer_timeout():
	# Clear current queue and insert Vein at the front
	attack_queue.clear()
	attack_queue.append(state.Vein)


func start_attack(attack_type):
	is_attacking = true
	player_previous_pos = get_tree().get_first_node_in_group("Player").global_position
	var tween = create_tween()
	match attack_type:
		state.Dash:
			animation_player.play("Dash")
			barrier.modulate = Color(1, 0, 0, 1)
			tween.tween_property(barrier, "modulate", Color(1, 1, 1, 1), 0.25)# red
		state.Throw:
			barrier.modulate =  Color(1, 1, 0, 1)
			tween.tween_property(barrier, "modulate", Color(1, 1, 1, 1), 0.25)# yellow
			animation_player.play("Throw")
		state.Vein:
			barrier.modulate =Color(0.5, 0, 0.5, 1)
			tween.tween_property(barrier, "modulate", Color(1, 1, 1, 1), 0.25)# purple
			animation_player.play("Vein")

func dash_attack():
	var instance = brain_projectile.instantiate()
	instance.current_state = instance.state.Dash
	add_child(instance)
	instance.global_position = self.global_position

func throw_attack():
	var instance = brain_projectile.instantiate()
	instance.current_state = instance.state.Thrown
	instance.start_pos = throw_pos.global_position
	instance.end_pos = player_previous_pos
	add_child(instance)
	instance.global_position = throw_pos.global_position

func vein_attack():
	var instance = brain_projectile.instantiate()
	instance.current_state = instance.state.Vein

	add_child(instance)
	instance.sprite_2d.hide()
	instance.animated_sprite_2d.play("Float")
	instance.global_position = throw_pos.global_position

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false

func _on_animation_player_animation_finished(anim_name):
	is_attacking = false

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var level = get_tree().current_scene
		level.reset_level()

func hit():
	if barrier_active:
		flash_barrier()
		return
	var tween = create_tween()
	tween.tween_property(sprite_2d,"modulate:v",1,0.25).from(15)
	hp -= 1
	match hp:
		2:
			health_bar.play("Half")
		1:
			health_bar.play("Empty")
	if hp == 0:
		queue_free()
	recover()
func flash_barrier(duration := 0.1):
	var tween = create_tween()
	tween.tween_property(barrier,"modulate:v",1,0.25).from(15)
	

func stagger():
	set_physics_process(false)
	stagger_timer.start()
	attack_timer.stop()
	barrier_active = false
	barrier.hide()
	animation_player.play("Stagger")
	
func recover():
	animation_player.play("Recover")
	barrier_active = true
	barrier.show()

func return_normal():
	set_physics_process(true)
