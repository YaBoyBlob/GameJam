extends RigidBody2D



func _ready() -> void: #used to catch the signals from the player hitbox
	get_parent().player.get_node("Hitbox").entered.connect(solid)
	get_parent().player.get_node("Hitbox").exited.connect(liquid)

func solid() -> void: # makes the block solid
	self.collision_layer = 1
	self.collision_mask = 3

func liquid() -> void: #removes the blocks collision, but lets it be pushed
	self.collision_layer = 2
	self.collision_mask = 2
