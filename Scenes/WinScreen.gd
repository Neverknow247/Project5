extends Control

var PlayerStats = ResourceLoader.PlayerStats
var score = PlayerStats.score

func _process(delta: float) -> void:
	update_score_label()

func update_score_label():
	$Title/VBoxContainer/Label.text = "YOU     LOSE"
	$Title/VBoxContainer/Label2.text = "Score: " + str(score)

func _on_StartButton_pressed() -> void:
	PlayerStats.score = 0
	get_tree().change_scene("res://World/World.tscn")


func _on_QuitButton_pressed() -> void:
	get_tree().quit()
