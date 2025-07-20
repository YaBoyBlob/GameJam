extends Node

var is_alive = true
var is_resetting = false
var lvl 
var cur_lvl
var finished = false
# Audio system
var current_level = 0
var current_track_index = 0
var current_audio: AudioStreamPlayer = null

# Audio files
const LVL_1 = preload("res://Audio/Levels/Lvl1.mp3")
const LVL_2 = preload("res://Audio/Levels/Lvl2.mp3")
const LVL_3 = preload("res://Audio/Levels/Lvl3.mp3")
const LVL_3_2 = preload("res://Audio/Levels/Lvl3-2.mp3")
const LVL_4 = preload("res://Audio/Levels/Lvl4.mp3")
const LVL_4_2 = preload("res://Audio/Levels/Lvl4-2.mp3")
const LVL_5 = preload("res://Audio/Levels/Lvl5.mp3")
const LVL_6 = preload("res://Audio/Levels/Lvl6.mp3")
const LVL_7 = preload("res://Audio/Levels/Lvl7.mp3")
const LVL_7_2 = preload("res://Audio/Levels/Lvl7-2.mp3")
const LVL_8 = preload("res://Audio/Levels/Lvl8.mp3")
const STAGE_STUCK = preload("res://Audio/Levels/StageStuck.mp3")
const BOSS = preload("res://Audio/Levels/Boss.mp3")
const BOSS_2 = preload("res://Audio/Levels/Boss-2.mp3")
const BOSS_3 = preload("res://Audio/Levels/Boss-3.mp3")
const BOSS_DEFEAT = preload("res://Audio/Levels/BossDefeat.mp3")

# Subtitle images
const SUB_1 = preload("res://Assets/Subtitles/SUB1.png")
const SUB_2 = preload("res://Assets/Subtitles/SUB2.png")
const SUB_3 = preload("res://Assets/Subtitles/SUB3.png")
const SUB_3_2 = preload("res://Assets/Subtitles/SUB3-2.png")
const SUB_4 = preload("res://Assets/Subtitles/SUB4.png")
const SUB_4_2 = preload("res://Assets/Subtitles/SUB4-2.png")
const SUB_5 = preload("res://Assets/Subtitles/SUB5.png")
const SUB_6 = preload("res://Assets/Subtitles/SUB6.png")
const SUB_7 = preload("res://Assets/Subtitles/SUB7.png")
const SUB_7_2 = preload("res://Assets/Subtitles/SUB7-2.png")
const SUB_8 = preload("res://Assets/Subtitles/SUB8.png")
const SUB_BOSS_1 = preload("res://Assets/Subtitles/SUB_BOSS-1.png")
const SUB_BOSS_2 = preload("res://Assets/Subtitles/SUB_BOSS-2.png")
const SUB_BOSS_3 = preload("res://Assets/Subtitles/SUB_BOSS-3.png")
const SUB_DEFEAT = preload("res://Assets/Subtitles/SUB_DEFEAT.png")
const SUB_STUCK = preload("res://Assets/Subtitles/SUB_STUCK.png")

# Track mapping per level
var level_audio_tracks = {
	1: [LVL_1],
	2: [LVL_2],
	3: [LVL_3, LVL_3_2],
	4: [LVL_4, LVL_4_2],
	5: [LVL_5],
	6: [LVL_6],
	7: [LVL_7, LVL_7_2],
	8: [LVL_8],
	9: [BOSS, BOSS_2, BOSS_3]
}

# Subtitles per track per level (must match audio count)
var subtitle_images = {
	1: [SUB_1],
	2: [SUB_2],
	3: [SUB_3, SUB_3_2],
	4: [SUB_4, SUB_4_2],
	5: [SUB_5],
	6: [SUB_6],
	7: [SUB_7, SUB_7_2],
	8: [SUB_8],
	9: [SUB_BOSS_1, SUB_BOSS_2, SUB_BOSS_3],
}

# Subtitle display
var subtitle_image: TextureRect = null
var richtextlabel = null

# Stuck system
var stuck_timer_started := false
var stuck_timer := Timer.new()



func _process(delta):
	if is_instance_valid(lvl) and cur_lvl == lvl.level:
		if is_alive:
			play_audio()
		is_alive = false
	else:
		is_alive = true

func play_audio():
	if is_instance_valid(current_audio):
		current_audio.stop()
		current_audio.queue_free()
		current_audio = null

	if is_instance_valid(subtitle_image):
		subtitle_image.queue_free()
		subtitle_image = null

	current_level = lvl.level
	current_track_index = 0
	_play_next_track()
	#Restart stuck timer if not boss stage
	if is_instance_valid(stuck_timer):
		stuck_timer.stop()

	if lvl.level != 9:
		if not is_inside_tree():
			await self.ready  # Ensure node is ready before adding child
		if not stuck_timer.is_inside_tree():
			add_child(stuck_timer)

		stuck_timer.one_shot = true
		stuck_timer.wait_time = 30
		if not stuck_timer.timeout.is_connected(_on_stuck_timeout):
			stuck_timer.timeout.connect(_on_stuck_timeout)
		stuck_timer.start()
func _play_next_track():
	var tracks = level_audio_tracks.get(current_level, [])
	var subtitles = subtitle_images.get(current_level, [])

	if current_track_index >= tracks.size():
		return

	if is_instance_valid(current_audio):
		current_audio.stop()
		current_audio.queue_free()
		current_audio = null

	if is_instance_valid(subtitle_image):
		subtitle_image.queue_free()
		subtitle_image = null

	var stream = tracks[current_track_index]
	var sub_texture =subtitles[current_track_index] if current_track_index < subtitles.size() else null
	current_track_index += 1

	if sub_texture != null:
		subtitle_image = TextureRect.new()
		subtitle_image.name = "Subtitle"
		subtitle_image.texture = sub_texture
		subtitle_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		subtitle_image.anchor_left = 0
		subtitle_image.anchor_top = 0
		subtitle_image.anchor_right = 0
		subtitle_image.anchor_bottom = 0
		subtitle_image.position = Vector2(144, 144)
		subtitle_image.custom_minimum_size = Vector2(256, 64)
		SubtitlesUI.add_child(subtitle_image)

	var audio = AudioStreamPlayer.new()
	audio.stream = stream
	audio.volume_db += 3
	add_child(audio)
	audio.play()

	audio.connect("finished", func():
		if is_instance_valid(subtitle_image):
			subtitle_image.queue_free()
			subtitle_image = null
		_play_next_track()
	)

	current_audio = audio

# 🧠 Custom single audio + subtitle playback (stuck, defeat, etc)
func play_custom_audio(stream: AudioStream, sub_texture: Texture2D):
	if is_instance_valid(current_audio):
		current_audio.stop()
		current_audio.queue_free()
		current_audio = null

	if is_instance_valid(subtitle_image):
		subtitle_image.queue_free()
		subtitle_image = null

	if sub_texture:
		subtitle_image = TextureRect.new()
		subtitle_image.name = "Subtitle"
		subtitle_image.texture = sub_texture
		subtitle_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		subtitle_image.anchor_left = 0
		subtitle_image.anchor_top = 0
		subtitle_image.anchor_right = 0
		subtitle_image.anchor_bottom = 0
		subtitle_image.position = Vector2(144, 144)
		subtitle_image.custom_minimum_size = Vector2(256, 64)
		SubtitlesUI.add_child(subtitle_image)

	var audio = AudioStreamPlayer.new()
	audio.stream = stream
	audio.volume_db += 3
	add_child(audio)
	audio.play()

	audio.connect("finished", func():
		if is_instance_valid(subtitle_image):
			subtitle_image.queue_free()
			subtitle_image = null
	)

	current_audio = audio

# ⏳ Called when stuck timer fires
func _on_stuck_timeout():
	if not is_instance_valid(lvl):
		return
	if lvl.level == 9:
		return  # Skip stuck audio on boss stage
	play_custom_audio(STAGE_STUCK, SUB_STUCK)
