extends Node2D
@onready var blink = $CanvasLayer/Blink
@onready var level_camera = $LevelCamera
@onready var player = $MainCharacter

@onready var block = $CanvasLayer/Block
@onready var ball = $CanvasLayer/Ball
@onready var plank = $CanvasLayer/Plank
@onready var reset = $CanvasLayer/Reset



var objects = 0
@export var level = 1

var box = preload("res://Units/block.tscn")
var bar = preload("res://Units/plank.tscn")
var circle = preload("res://Units/ball.tscn")
var music = preload("res://Audio/MusicSample.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	if level == 1:
		blink.play("Blink-Open")

func _physics_process(delta):
	for nodes in get_tree().get_nodes_in_group("Objects"):
		if nodes.global_position.y > 400:
			nodes.queue_free()
			objects -=1
	if player.global_position.y > 400:
		reset_level()
	

func _on_area_2d_area_exited(area): #switch new level
	if area.get_parent() == player:
		level +=1
		get_tree().change_scene_to_file("res://Scenes/level_" + str(level) + ".tscn")

	
func _on_reset_button_down(): #reset everything
	Select.play()
	reset_level()
func reset_level():
	get_tree().reload_current_scene()
	#player.global_position = level_camera.global_position - Vector2(240,0)
	#player.velocity = Vector2.ZERO #reset momentum
	#
	#for nodes in get_tree().get_nodes_in_group("Objects"):
	#	nodes.queue_free()
	#objects = 0
	#for enemy in get_tree().get_nodes_in_group("Enemy"):
	#	enemy.global_position = enemy.spawn_pos
	#	if enemy.direction == 1:
	#		enemy.flip()
	#		enemy.timer.stop()
	#		enemy.timer.start()
	#for bullet in get_tree().get_nodes_in_group("Projectile"):
	#	bullet.queue_free()
func _on_box_button_down(): #spawn blocks
	if objects <3:
		Select.play()
		var instance = box.instantiate()
		add_child(instance)
		instance.position = player.global_position + Vector2(50 * player.prev_direction , 0)
		objects += 1


func _on_ball_button_down(): #spawn ball
	if objects <3:
		Select.play()
		var instance = circle.instantiate()
		add_child(instance)
		instance.position = player.global_position + Vector2(50 * player.prev_direction , 0)
		objects += 1


func _on_plank_button_down(): #spawn planks
	if objects <3:
		Select.play()
		var instance = bar.instantiate()
		add_child(instance)
		instance.position = player.global_position + Vector2(100 * player.prev_direction , 0)
		objects += 1


func _on_area_2d_area_entered(area):
	pass
