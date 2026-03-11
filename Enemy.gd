extends Area2D

var speed = 150
var health = 3 
var gem_scene = preload("res://Gem.tscn")
var health_drop_scene = preload("res://HealthDrop.tscn")
var death_effect_scene = preload("res://DeathEffect.gd") 
var knockback = Vector2.ZERO

func _process(delta):
	var player = get_tree().get_root().find_node("Player", true, false)
	if player:
		# Calculate movement toward player
		var direction = (player.global_position - global_position).normalized()
		
		# Smoothly reduce knockback over time so they don't slide forever
		knockback = knockback.move_toward(Vector2.ZERO, 500 * delta)
		
		# Move the enemy (Normal movement + any impact force)
		global_position += (direction * speed + knockback) * delta

func take_damage(amount, source_pos):
	health -= amount
	
	# Reduced Pushback: Calculate the direction away from the bullet
	var push_dir = (global_position - source_pos).normalized()
	knockback = push_dir * 300 
	
	# Impact Flash: Briefly turns bright red to show they were hit
	$Sprite.modulate = Color(10, 1, 1) 
	yield(get_tree().create_timer(0.1), "timeout")
	$Sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		die()

func die():
	# Instance the particle death effect
	var effect = Node2D.new()
	effect.set_script(death_effect_scene)
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	# --- LOOT TABLE LOGIC ---
	var roll = randf() # Generates a number between 0.0 and 1.0
	
	if roll < 0.10: # 10% chance for Health
		var health_drop = health_drop_scene.instance()
		get_tree().current_scene.add_child(health_drop)
		health_drop.global_position = global_position
	else: # 90% chance for Gem
		var gem = gem_scene.instance()
		get_tree().current_scene.add_child(gem)
		gem.global_position = global_position
	
	# Remove the enemy from the scene
	queue_free()
