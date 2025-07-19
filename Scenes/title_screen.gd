extends Node2D
@onready var screen_animations = $ScreenAnimations
@onready var title_screen_sprite = $TitleScreenSprite
@onready var UI = $UIs
@onready var start_button = $UIs/StartButton
@onready var exit_button = $UIs/ExitButton
@onready var blink = $Blink






func _ready():
	title_screen_sprite.play("Start")
	screen_animations.play("BlackSceen")


func _process(_delta):
	pass





func _on_title_screen_sprite_animation_finished():
	await get_tree().create_timer(0.5).timeout #lingers on Black screen for a bit
	screen_animations.play("Credits")
	await get_tree().create_timer(3.0).timeout #waits 3 second then switch to home screen
	UI.show()
	screen_animations.play("HomeSreen")
	Music.play()


func _on_blink_animation_finished():
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_exit_button_button_down():
	get_tree().quit()


func _on_start_button_button_down():
	if !blink.is_playing(): #Prevent it playing again during the animation
		Confirm.play()
		blink.play("Blink-Close")


func _on_exit_button_mouse_entered():
	if !Select.playing:
		Select.play()
