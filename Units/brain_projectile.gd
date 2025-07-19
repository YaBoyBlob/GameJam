extends Node2D

var speed = 6000.0
var direction = Vector2.LEFT

var start_pos : Vector2
var end_pos : Vector2
var time_passed = 0.0
var distance
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var Hitbox = $Hitbox/CollisionShape2D
@onready var VeinHitbox = $VeinHitbox/CollisionShape2D
var in_anime = false
@onready var sprite_2d = $Sprite2D


enum state{
	Dash,
	Thrown,
	Vein
}
var current_state 
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("Idle")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match current_state:
		state.Dash:
			position += direction * speed * delta
		state.Thrown:
			time_passed += delta
			var t = (time_passed / 0.6) * 2.0
			
			if t <= 1.0:
				global_position = start_pos.lerp(end_pos,t)
			elif t <= 2.0:
				global_position = end_pos.lerp(start_pos, t -1.0)
			else :
				await get_tree().create_timer(0.05)
				queue_free()
		state.Vein:
			if !in_anime:
				in_anime = true
				$BrainFloat.show()
				
				
			
func vein_attack():
	sprite_2d.show()
	$BrainFloat.global_position = $Sprite2D.global_position
	animated_sprite_2d.play("Vein")

func activate_hit():
	Hitbox.disabled = true
	VeinHitbox.disabled = false


func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var level = get_tree().current_scene
		level.reset_level()
	if area.get_parent().is_in_group("Objects"):
		area.get_parent().vanish()

func _on_vein_hitbox_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var level = get_tree().current_scene
		level.reset_level()
	if area.get_parent().is_in_group("Objects"):
		area.get_parent().vanish()
