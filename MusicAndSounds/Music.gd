extends Node

export(Array, AudioStream) var music_list = []

var music_list_index = 0
var is_playing = false

onready var musicPlayer = $AudioStreamPlayer

func _ready() -> void:
	music_list.shuffle()

func list_play():
	is_playing = true
	assert(music_list.size() > 0)
	musicPlayer.stream = music_list[music_list_index]
	musicPlayer.play()
	music_list_index += 1
	if music_list_index == music_list.size():
		music_list_index = 0

func list_stop():
	is_playing = false
	musicPlayer.stop()
	

func _on_AudioStreamPlayer_finished() -> void:
	music_list.shuffle()
	list_play()
