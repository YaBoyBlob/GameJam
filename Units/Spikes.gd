extends ColorRect

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("Player"):
		var level = get_tree().current_scene
		level.reset_level()
