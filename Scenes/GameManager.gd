extends Node

var is_alive = true
var is_resetting = false
var lvl 
var cur_lvl

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  is_instance_valid(lvl) and cur_lvl == lvl.level:
		is_alive = false
	else :
		is_alive = true

func update_lvl():
	is_alive = true
