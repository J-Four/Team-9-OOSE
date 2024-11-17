extends AudioStreamPlayer2D

@onready var effect_player: AudioStreamPlayer2D = get_node("AudioPlayerEffect")
@onready var effect_player_2: AudioStreamPlayer2D = get_node("AudioPlayerEffect2")
@onready var effect_player_3: AudioStreamPlayer2D = get_node("AudioPlayerEffect3")


func play_music(song: AudioStream, rand_pitch_shift_offset: float = 0.0):
	pitch_scale = 1.0
	if rand_pitch_shift_offset != 0:
		pitch_scale = randf_range(-rand_pitch_shift_offset + 1, 1 + rand_pitch_shift_offset)
	
	stream = song
	play()


func stop_music():
	stop()
	stream = null


func play_sound_effect(sfx: AudioStream, rand_pitch_shift_offset: float = 0.0):
	effect_player.pitch_scale = 1.0
	if rand_pitch_shift_offset != 0:
		effect_player.pitch_scale = randf_range(-rand_pitch_shift_offset + 1, 1 + rand_pitch_shift_offset)
	
	effect_player.stream = sfx
	effect_player.play()


func play_sound_effect_2(sfx: AudioStream, rand_pitch_shift_offset: float = 0.0):
	effect_player_2.pitch_scale = 1.0
	if rand_pitch_shift_offset != 0:
		effect_player_2.pitch_scale = randf_range(-rand_pitch_shift_offset + 1, 1 + rand_pitch_shift_offset)
	
	effect_player_2.stream = sfx
	effect_player_2.play()


func play_sound_effect_3(sfx: AudioStream, rand_pitch_shift_offset: float = 0.0):
	effect_player_3.pitch_scale = 1.0
	if rand_pitch_shift_offset != 0:
		effect_player_3.pitch_scale = randf_range(-rand_pitch_shift_offset + 1, 1 + rand_pitch_shift_offset)
	
	effect_player_3.stream = sfx
	effect_player_3.play()
