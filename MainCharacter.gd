extends CharacterBody2D
class_name PLAYER

const SPEED = 200
const JUMP_VELOCITY = -350
@onready var animated_sprite_2d = $AnimatedSprite2D
var direction = 1
var prev_direction = 1
func _physics_process(delta):
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
	
	move_and_slide()


func animation_handler():
	if is_on_floor():
		if velocity.x == 0:
			animated_sprite_2d.play("Idle")
			
		elif velocity.x != 0:
			animated_sprite_2d.play("Run")
			
	



