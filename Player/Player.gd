extends KinematicBody2D

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

export (int) var accel = 500
export (int) var max_speed = 75
export (int) var v_accel = 250
export (float) var v_max_speed = 37.5
export (float) var friction = 0.25
export (int) var gravity = 200
export (int) var max_slope_angle = 46

enum {
	MOVE,
	ATTACK
}

var state = MOVE
var invincible = false setget set_invincible
var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO

onready var sprite = $Sprite
onready var animator = $AnimationPlayer
onready var cameraFollow = $CameraFollow
onready var blinkAnimator = $AnimationPlayer2

signal player_died

func set_invincible(value):
	invincible = value

func _ready() -> void:
	PlayerStats.connect("player_died", self, "_on_died")
	MainInstances.Player = self
	call_deferred("assign_world_camera")

func queue_free():
	MainInstances.Player = null
	.queue_free()

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			var input_vector = get_input_vector()
			apply_horizontal_force(input_vector, delta)
			apply_vertical_force(input_vector, delta)
			apply_friction(input_vector)
			update_snap_vector()
			update_animations(input_vector)
			move()

		
		ATTACK:
			attack()
			attack_check()

func assign_world_camera():
	cameraFollow.remote_path = MainInstances.WorldCamera.get_path()

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector

func apply_horizontal_force(input_vector, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * accel * delta
		motion.x = clamp(motion.x, -max_speed, max_speed)

func apply_vertical_force(input_vector, delta):
	if input_vector.y != 0:
		motion.y += input_vector.y * v_accel * delta
		motion.y = clamp(motion.y, -v_max_speed, v_max_speed)

func apply_friction(input_vector):
	if input_vector.x == 0:
		motion.x = lerp(motion.x, 0, friction)
	if input_vector.y == 0:
		motion.y = lerp(motion.y, 0, friction)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN

func update_animations(input_vector):
	var facing = input_vector.x
	if facing != 0:
		sprite.scale.x = facing
	if input_vector != Vector2.ZERO:
		animator.playback_speed = 1
		animator.play("Run")
#		animator.playback_speed = sprite.scale.x
	else:
		animator.playback_speed = 1
		animator.play("Idle")
	if Input.is_action_just_pressed("Attack"):
		PlayerStats.health -= 1
		SoundFx.play("Hurt", 1, -15)
		animator.playback_speed = 1
		animator.play("Attack1")
		state = ATTACK

func move():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_motion = motion
	var last_position = position
	
	motion = move_and_slide(motion)
	
	# Prevent Sliding (hack)
#	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
#		position.x = last_position.x

func create_step():
	SoundFx.play("Step", 1, -15)

func attack_check():
	pass
#	if Input.is_action_just_pressed("Attack") and animator.current_animation_position == .4 or .5:
#		animator.animation_set_next("Attack1","Attack2")
#	else:
#		animator.clear_queue()
#		animator.clear_caches()

func attack():
	if not animator.is_playing():
		state = MOVE

func _on_died():
	animator.play()
	emit_signal("player_died")


func _on_Hurtbox_hit(damage) -> void:
	PlayerStats.health -= damage
	SoundFx.play("Hurt", 1, -15)
#	if not invincible:
##		SoundFX.play("Hurt", 1, -5)
#		PlayerStats.health -= damage
#		blinkAnimator.play("Blink")
