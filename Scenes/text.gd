extends RichTextLabel

@export var animation_progress = 0.0
var bounce_dur = 0.0

func _enter_tree():
	GameManager.richtextlabel = self

func _exit_tree():
	GameManager.richtextlabel = null

func _ready():
	$AnimationPlayer.play("appear")
func get_char_anime_time(character_index: int) -> float:
	var total_char = get_total_character_count() + bounce_dur
	var time_pos = animation_progress * total_char
	
	return clamp((character_index + bounce_dur - time_pos), 0.0 , bounce_dur)/ bounce_dur
