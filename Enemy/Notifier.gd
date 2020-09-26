extends Area2D

signal attack

func _physics_process(delta: float) -> void:
	attack()

func attack():
	var bodies = get_overlapping_bodies()
	for b in bodies:
		if b.name == "Player":
			emit_signal("attack")
