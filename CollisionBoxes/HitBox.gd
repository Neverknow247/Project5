extends Area2D

export (int) var damage = 1

func _on_HitBox_area_entered(hurtbox: Area2D) -> void:
	hurtbox.emit_signal("hit", damage)
