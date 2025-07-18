extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
var attack_interval = 1.0
var is_attacking : bool = false
@onready var animation_player = $AnimationPlayer

var brain_projectile = preload("res://Units/brain_projectile.tscn")
enum state{
	Idle,
	Dash,
	Throw,
	Vein
}
var combat_states = [state.Dash]#,state.Throw,state.Vein]
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if !is_attacking:
		animated_sprite_2d.play("Idle")
		attack_interval = randf_range(1.0,2.5)
		timer.start(attack_interval)
		is_attacking = true


func _on_timer_timeout():
		var random_state = combat_states.pick_random()
		match random_state:
			state.Dash:
				dash_attack()
			state.Throw:
				throw_attack()
			state.Vein:
				vein_attack()
		
func dash_attack():
	animated_sprite_2d.play("Dash")
	var instance = brain_projectile.instantiate()
	instance.current_state = instance.state.Dash
	add_child(instance)
	
func throw_attack():
	animated_sprite_2d.play("Start")

func vein_attack():
	animated_sprite_2d.play("Vein")

func _on_animated_sprite_2d_animation_finished():
	is_attacking = false
	
