extends Area2D

signal entered
signal exited

func _ready() -> void: #connects collision detection of hitbox to the signal functions
	connect("area_entered", transfer)
	connect("area_exited",untransfer)

func transfer(_area): #signal functions
	emit_signal("entered")
func untransfer(_area):
	emit_signal("exited")
