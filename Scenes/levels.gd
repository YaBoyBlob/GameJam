extends Node2D
@onready var blink = $CanvasLayer/Blink
@onready var level_camera = $LevelCamera
@onready var player = $MainCharacter

@onready var block = $CanvasLayer/Block
@onready var ball = $CanvasLayer/Ball
@onready var plank = $CanvasLayer/Plank
@onready var reset = $CanvasLayer/Reset



var objects = 0
var level = 1
var box = preload("res://Units/block.tscn")
var bar = preload("res://Units/plank.tscn")
var circle = preload("res://Units/ball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	blink.play("Blink-Open")

func _physics_process(delta):
	if player.global_position.y > 400:
		reset_level()
	for nodes in get_tree().get_nodes_in_group("Objects"):
		if nodes.global_position.y > 400:
			nodes.queue_free()
			objects -=1

func _on_area_2d_area_exited(area): #switch new level
	if area.get_parent().is_in_group("Enemy"):
		area.get_parent().active = false
	if area.get_parent() == player:
		if level > 0:
			level_camera.global_position.x += 640
		level +=1
		match level:
			2:
				block.show()
				reset.show()
			3:
				ball.show()
			4:
				plank.show()
		for nodes in get_tree().get_nodes_in_group("Objects"):
			nodes.queue_free()
		objects = 0
	
func _on_reset_button_down(): #reset everything
	reset_level()
func reset_level():
	player.global_position = level_camera.global_position - Vector2(240,-180)
	player.velocity = Vector2.ZERO
	for nodes in get_tree().get_nodes_in_group("Objects"):
		nodes.queue_free()
	objects = 0
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.global_position = enemy.spawn_pos
		if enemy.direction == 1:
			enemy.flip()
			enemy.timer.stop()
			enemy.timer.start()
	for bullet in get_tree().get_nodes_in_group("Projectile"):
		bullet.queue_free()
func _on_box_button_down(): #spawn blocks
	if objects <3:
		var instance = box.instantiate()
		add_child(instance)
		instance.position = player.global_position + Vector2(50 * player.prev_direction , 0)
		objects += 1


func _on_ball_button_down(): #spawn ball
	if objects <3:
		var instance = circle.instantiate()
		add_child(instance)
		instance.position = player.global_position + Vector2(50 * player.prev_direction , 0)
		objects += 1


func _on_plank_button_down(): #spawn planks
	if objects <3:
		var instance = bar.instantiate()
		add_child(instance)
		instance.position = player.global_position + Vector2(50 * player.prev_direction , 0)
		objects += 1


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Enemy"):
		if area.get_parent().global_position.x >= self.global_position.x - 320:
			area.get_parent().active = true
