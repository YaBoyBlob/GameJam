extends Node2D
@onready var blink = $CanvasLayer/Blink
@onready var level_camera = $LevelCamera
@onready var player = $MainCharacter

var box = preload("res://Units/block.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	blink.play("Blink-Open")

var level = 1

func _on_area_2d_area_exited(area):
	if level > 0:
		level_camera.global_position.x += 640
	level +=1



func _on_reset_button_down():
	player.global_position = level_camera.global_position - Vector2(240,0)
	player.velocity.x = 0
	player.velocity.y = 0


func _on_box_button_down():
	var instance = box.instantiate()
	add_child(instance)
	instance.position = player.global_position + Vector2(50 * player.prev_direction , 0)
