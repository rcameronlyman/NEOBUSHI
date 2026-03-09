extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var spawn_range = 700 
var safety_margin = 500 

# Difficulty settings
var base_spawn_time = 2.0
var minimum_spawn_time = 0.5
var difficulty_increase_rate = 0.05

func _ready():
	$SpawnTimer.wait_time = base_spawn_time
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	spawn_enemy()
	increase_difficulty()

func spawn_enemy():
	var player = get_tree().get_root().find_node("Player", true, false)
	
	if not player:
		return

	# 1. Calculate spawn position relative to the moving player
	var random_angle = rand_range(0, TAU)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	var distance = rand_range(safety_margin, spawn_range)
	var spawn_pos = player.global_position + (direction * distance)

	# 2. Instance the enemy
	var enemy = enemy_scene.instance()
	
	# 3. CRITICAL FIX: Add the enemy to the WORLD root, not this spawner.
	# This prevents the "enemies moving with the player" illusion.
	get_tree().current_scene.add_child(enemy)
	
	# 4. Set position AFTER adding to scene
	enemy.global_position = spawn_pos

func increase_difficulty():
	if $SpawnTimer.wait_time > minimum_spawn_time:
		$SpawnTimer.wait_time -= difficulty_increase_rate
