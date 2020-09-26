extends CanvasLayer

var PlayerStats = ResourceLoader.PlayerStats
var score = 0

onready var scoreLabel = $VBoxContainer/ScoreLabel

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	score = PlayerStats.score
	update_score_label()

func update_score_label():
	scoreLabel.text = "Score: " + str(score)
