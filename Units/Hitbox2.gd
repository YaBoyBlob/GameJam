extends Area2D
signal midE

func _ready() -> void: #ignor this, it happened during my decent into madness
	print ("hi")

func transferE() -> void:  #ignor this, it happened during my decent into madness
	emit_signal("midE")
