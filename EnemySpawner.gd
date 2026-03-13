extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var spawn_range = 800 
var safety_margin = 550 

# --- SWARM SETTINGS ---
var base_spawn_time = 1.5          # Start faster
var minimum_spawn_time = 0.2       # Rapid-fire spawning
var difficulty_increase_rate = 0.08 # Ramp up intensity quickly
var enemies_per_burst = 3          # How many spawn at once (Increase this for more chaos!)

# NEW: High-intensity testing ceiling
var max_enemies = 750

func _ready():
	$SpawnTimer.wait_time = base_spawn_time
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	var current_enemy_count = get_tree().get_nodes_in_group("enemies").size()
	
	# Only spawn if we haven't hit the massive ceiling
	if current_enemy_count < max_enemies:
		# SWARM LOGIC: Spawn a cluster instead of just one
		for i in range(enemies_per_burst):
			if current_enemy_count + i < max_enemies:
				spawn_enemy()
	
	increase_difficulty()

func spawn_enemy():
	var player = get_tree().get_root().find_node("Player", true, false)
	
	if not player:
		return

	# Calculate spawn position in a circle around the player
	var random_angle = rand_range(0, TAU)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	var distance = rand_range(safety_margin, spawn_range)
	var spawn_pos = player.global_position + (direction * distance)

	var enemy = enemy_scene.instance()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawn_pos

func increase_difficulty():
	# Ramp up both the speed of spawning AND the number of enemies per burst
	if $SpawnTimer.wait_time > minimum_spawn_time:
		$SpawnTimer.wait_time -= difficulty_increase_rate
	
	# Every time the timer hits its fastest speed, consider increasing enemies_per_burst
	# (Optional: uncomment below if you want it to get truly insane)
	# if $SpawnTimer.wait_time <= minimum_spawn_time and enemies_per_burst < 10:
	#	enemies_per_burst += 1
