extends AudioStreamPlayer2D

@onready var effect_player: AudioStreamPlayer2D = get_node("AudioPlayerEffect")


func play_music(song: AudioStream, rand_pitch_shift_offset: float = 0.0):
	pitch_scale = 1.0
	if rand_pitch_shift_offset != 0:
		pitch_scale = randf_range(-rand_pitch_shift_offset + 1, 1 + rand_pitch_shift_offset)
	
	stream = song
	play()


func play_sound_effect(sfx: AudioStream, rand_pitch_shift_offset: float = 0.0):
	effect_player.pitch_scale = 1.0
	if rand_pitch_shift_offset != 0:
		effect_player.pitch_scale = randf_range(-rand_pitch_shift_offset + 1, 1 + rand_pitch_shift_offset)
	
	effect_player.stream = sfx
	effect_player.play()
