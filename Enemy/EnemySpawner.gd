extends Node2D

const Enemy = preload("res://Enemy/Skeleton.tscn")

var speed_up = 0

onready var spawnPoints = $SpawnPoints

func get_spawn_position():
	var points = spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position

func spawn_enemy():
	var spawn_position = get_spawn_position()
	var enemy = Enemy.instance()
	var main = get_tree().current_scene
	main.add_child(enemy)
	enemy.global_position = spawn_position
#	enemy.speed = enemy.speed + speed_up
#	speed_up += .5
	$Timer.wait_time -= .0025

func _on_Timer_timeout() -> void:
	spawn_enemy()
