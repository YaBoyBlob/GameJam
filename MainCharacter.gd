extends CharacterBody2D
class_name PLAYER

const SPEED = 180
const JUMP_VELOCITY = -350
const PUSH_FORCE = 3.0

var is_pushing = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var ray_cast_2d = $RayCast2D

var direction = 1
var prev_direction = 1
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

	move_and_slide()

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

func animation_handler():
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite_2d.play("Idle")
			
		elif velocity.x != 0:
			animated_sprite_2d.play("Run")
			
	





