extends Node2D
var life_time = 1.5
var speed = 500
var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(life_time).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed * direction * delta
	


func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var level = get_tree().current_scene
		area.get_parent().hit(1)
		queue_free()
	if area.get_parent().is_in_group("Objects"):
		queue_free()
		
