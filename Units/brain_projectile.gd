extends Node2D

var speed = 2000.0
var direction = Vector2.LEFT
enum state{
	Dash,
	Thrown,
	Vein
}
var current_state 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		state.Dash:
			position += direction * speed * delta
			
