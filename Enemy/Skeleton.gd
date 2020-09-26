extends KinematicBody2D

var health_bottle = preload("res://Items/Health.tscn")

var MainInstances = ResourceLoader.MainInstances
var PlayerStats = ResourceLoader.PlayerStats

export var health = 1
export (int) var accel = 250
export (int) var max_speed = 25

enum {
	MOVE,
	ATTACK,
	DIE
}

var state = MOVE
var motion = Vector2.ZERO
var dead = false

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			$AnimationPlayer.play("Run")
			var player = MainInstances.Player
			if player != null:
				chase_player(player, delta)
		ATTACK:
			finish_attack()
		DIE:
			_die()

func chase_player(player, delta):
	var diretion = (player.global_position - global_position).normalized()
	motion += diretion * accel * delta
	motion = motion.clamped(max_speed)
	if global_position > player.global_position:
		$Sprite.scale.x = -1
	else:
		$Sprite.scale.x = 1
	motion = move_and_slide(motion)
		

func finish_attack():
	if not $AnimationPlayer.is_playing():
		state = MOVE

func _on_Hurtbox_hit(damage) -> void:
	SoundFx.play("EnemyDie", 1, -15)
	PlayerStats.score += 1
	dead = true
	state = DIE

func _die():
	$AnimationPlayer.play("Die")


func _on_Notifier_body_entered(body: Node) -> void:
	$AnimationPlayer.play("Attack1")
	state = ATTACK

func create_health():
	if PlayerStats._create == true:
		Utils.instance_scene_on_main(health_bottle, global_position)

func _on_Notifier_attack() -> void:
	if dead == false:
		$AnimationPlayer.play("Attack1")
		state = ATTACK
