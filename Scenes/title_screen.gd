extends Node2D
@onready var screen_animations = $ScreenAnimations
@onready var title_screen_sprite = $TitleScreenSprite
@onready var UI = $UIs
@onready var start_button = $UIs/StartButton
@onready var exit_button = $UIs/ExitButton
@onready var blink = $Blink
@onready var new_title = $NewTitle
@onready var confirmed_title = $ConfirmedTitle






func _ready():
	title_screen_sprite.play("Start")
	screen_animations.play("BlackSceen")
	




func _on_new_title_text_submitted(new_text):
	if new_text == "":
		return
	confirmed_title.text = new_text
	confirmed_title.show()
	new_title.hide()
	UI.show()




func _on_title_screen_sprite_animation_finished():
	await get_tree().create_timer(0.5).timeout #lingers on Black screen for a bit
	screen_animations.play("Credits")
	await get_tree().create_timer(2.5).timeout #waits 2.5 second then switch to home screen
	if !GameManager.finished:
		UI.show()
		screen_animations.play("HomeSreen")
		Music.play()
	else:
		screen_animations.play("NewScreen")
		new_title.grab_focus()
		new_title.show()

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





