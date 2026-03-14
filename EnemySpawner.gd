extends Node2D

var enemy_scene = preload("res://Enemy.tscn")

# --- SPAWN DISTANCES ---
# Increased to ensure they spawn outside the camera view (1000+)
var spawn_range = 1400 
var safety_margin = 1100 

# --- SWARM SETTINGS ---
var base_spawn_time = 2.0          # Slightly slower start
var minimum_spawn_time = 0.5       # Reasonable cap for high intensity
var difficulty_increase_rate = 0.02 # Much smoother ramp up (was 0.08)
var enemies_per_burst = 2          # Dropped from 3 to 2 for better pacing

# NEW: High-intensity testing ceiling
var max_enemies = 50

func _ready():
	$SpawnTimer.wait_time = base_spawn_time
	$SpawnTimer.start()

func _on_SpawnTimer_timeout():
	# Counting "mobs" specifically so SupplyCrates don't block spawns
	var current_enemy_count = get_tree().get_nodes_in_group("mobs").size()
	
	if current_enemy_count < max_enemies:
		for i in range(enemies_per_burst):
			if current_enemy_count + i < max_enemies:
				spawn_enemy()
	
	increase_difficulty()

func spawn_enemy():
	var player = get_tree().get_root().find_node("Player", true, false)
	
	if not player:
		return

	# Calculate spawn position in a circle outside the view
	var random_angle = rand_range(0, TAU)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	var distance = rand_range(safety_margin, spawn_range)
	var spawn_pos = player.global_position + (direction * distance)

	var enemy = enemy_scene.instance()
	
	# Important: Ensure the enemy is added to "mobs" for the count check
	enemy.add_to_group("mobs")
	
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = spawn_pos

func increase_difficulty():
	if $SpawnTimer.wait_time > minimum_spawn_time:
		$SpawnTimer.wait_time -= difficulty_increase_rate
