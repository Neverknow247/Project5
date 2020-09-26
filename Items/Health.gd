extends StaticBody2D

var PlayerStats = ResourceLoader.PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_Area2D_body_entered(body: Node) -> void:
	PlayerStats.health += 1
	SoundFx.play("Pickle", 1, -5)
	queue_free()
