extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var spawn_range = 700 
var safety_margin = 500 

# Difficulty settings
var base_spawn_time = 2.0
var minimum_spawn_time = 0.5
var difficulty_increase_rate = 0.05

# NEW: Spawn ceiling increased 5x to 750 for high-intensity testing
var max_enemies = 750

func _ready():
	$SpawnTimer.wait_time = base_spawn_time
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	# Only spawn if the current count is below the new 750 ceiling
	if get_tree().get_nodes_in_group("enemies").size() < max_enemies:
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
	
	# 3. Add to the WORLD root to prevent movement illusion
	get_tree().current_scene.add_child(enemy)
	
	# 4. Set position AFTER adding to scene
	enemy.global_position = spawn_pos

func increase_difficulty():
	if $SpawnTimer.wait_time > minimum_spawn_time:
		$SpawnTimer.wait_time -= difficulty_increase_rate
