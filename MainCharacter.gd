extends CharacterBody2D
class_name PLAYER

const SPEED = 180
const JUMP_VELOCITY = -350
const PUSH_FORCE = 3.0
var is_pushing = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var ray_cast_2d = $RayCast2D
var alive = true
var direction = 1
var prev_direction = 1
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
	if is_on_floor():
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
	
	move_and_slide()

func push_objects():
	#for body in hitbox.get_overlapping_bodies():
	#	if body is RigidBody2D:
	var lastCollision = get_last_slide_collision()
	
	if lastCollision:
		var collider = lastCollision.get_collider()
	
		if collider and collider.name == "Ball":
			var push_direction = (collider.global_position - global_position).normalized()
	
			var pushOnSide = abs(push_direction.y) < 0.5
			
			if pushOnSide:
				is_pushing = true
				var push_x = sign(push_direction.x)
				var PushVelocity = Vector2(PUSH_FORCE * push_x, 0)
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





