extends RichTextEffect
class_name AppearEffect
var bbcode = "appear"

func get_anime_time(character_fx):
	return GameManager.richtextlabel.get_char_anime_time(character_fx.relative_index)
func bounce(normalized_time, decay_factor=12.0) -> float:
	return sin(8.0 * (PI / 2.0) * normalized_time) * pow(2.0, decay_factor * (normalized_time -1.0))
func _process_custom_fx(char_fx):
	var animation_time = get_anime_time(char_fx)
	char_fx.y = bounce(animation_time, 10.5) * 50.0
	char_fx.color.a *= (1.0-animation_time)
	return true
