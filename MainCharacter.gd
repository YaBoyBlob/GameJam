extends CharacterBody2D
class_name PLAYER

const SPEED = 160
const JUMP_VELOCITY = -350
const PUSH_FORCE = 3.0
var is_pushing = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var coyote_timer = $CoyoteTimer
@onready var health_bar = $HealthBar

var single_jump = 0
var alive = true
var direction = 1
var prev_direction = 1
@export var hp = 3
func _ready():
	if GameManager.is_alive == false:
		set_physics_process(false)
		animated_sprite_2d.play("Spawn")
		await get_tree().create_timer(1.0).timeout
		set_physics_process(true)
func _physics_process(delta):
	is_pushing = false
	animation_handler()
	if !is_on_floor():
		velocity.y += delta * 1000
	if is_on_floor() || (!coyote_timer.is_stopped() && velocity.y>=0):
		if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("space") :
			velocity.y = JUMP_VELOCITY
			animated_sprite_2d.play("Jump")

	direction = Input.get_axis("left", "right") #go left/right
	if direction!=0:
		prev_direction = direction
	velocity.x = direction * SPEED
	
	if direction < 0 :
		animated_sprite_2d.flip_h = true # look left
	elif direction > 0 :
		animated_sprite_2d.flip_h = false #look right
	
	push_objects()
	check_push()
	
	var was_on_floor = is_on_floor()
	move_and_slide()
	if was_on_floor && !is_on_floor():
		coyote_timer.start()


func push_objects():
	#for body in hitbox.get_overlapping_bodies():
	#	if body is RigidBody2D:
			var lastCollision = get_last_slide_collision()
			
			if lastCollision:
				var collider = lastCollision.get_collider()
				
				if collider and collider.is_in_group("Objects"):
					var push_direction = (collider.global_position - global_position).normalized()
					
					var pushOnSide = abs(push_direction.y) < 0.5
					
					if pushOnSide:
						is_pushing=true
						var PushVelocity = Vector2(PUSH_FORCE * push_direction)
						collider.linear_velocity += PushVelocity

func check_push():
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider and collider.name == "Block":
			var direction = (collider.global_position - global_position).normalized()
			
			# Only push from side
			if abs(direction.y) < 0.3:
				var push_amount = 150.0  # tweak this value
				var push_force = (Vector2(75 * sign(direction.x), 0))
				var lift = Vector2(0,-5)
				collider.apply_impulse(push_force,lift)

				
func hit(damage):
	if alive:
		var tween = create_tween()
		flash_white()
		health_bar.modulate = Color(1, 1, 1, 1)
		tween.tween_property(health_bar, "modulate", Color(1, 1, 1, 0), 0.25)
		hp -= damage
		match hp:
			2:
				health_bar.play("Half")
			1:
				health_bar.play("Empty")
		if hp <= 0:
			health_bar.play("Empty")
			var level = get_tree().current_scene
			level.reset_level()
			dead()

func flash_white():
	var shader_material := animated_sprite_2d.material as ShaderMaterial
	shader_material.set_shader_parameter("enable_flash", true)
	await get_tree().create_timer(0.25).timeout
	shader_material.set_shader_parameter("enable_flash", false)


func animation_handler():
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite_2d.play("Idle")
			
		elif velocity.x != 0:
			animated_sprite_2d.play("Run")
			
func dead():
	if alive:
		alive = false
		GameManager.is_alive = false
		set_physics_process(false)
		animated_sprite_2d.play("Dead")




