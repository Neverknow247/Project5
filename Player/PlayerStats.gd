extends Resource
class_name PlayerStats

var _create = true
var max_health = 4
var health = max_health setget set_health
var score = 0 setget set_score

signal player_health_changed(value)
signal player_died

func set_health(value):
	if value < health:
		Events.emit_signal("add_screenshake", 0.2, 0.25)
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", health)
	if health == 0:
		emit_signal("player_died")

func refill_stats():
	self.health = max_health

func set_score(value):
	score = value

func _on_score_up():
	self.score += 1
