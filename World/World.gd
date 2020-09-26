extends Node

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

onready var currentLevel = $Level_01

func _ready() -> void:
	$TileMap2.visible = false
	VisualServer.set_default_clear_color(Color(17.0/255.0, 16.0/255.0, 26.0/255.0))
	if Music.is_playing:
		pass
	else:
		Music.list_play()
	
	MainInstances.Player.connect("player_died", self, "_on_player_died")

func _on_player_died() -> void:
	yield(get_tree().create_timer(2.0),"timeout")
	PlayerStats.health = PlayerStats.max_health
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/WinScreen.tscn")
