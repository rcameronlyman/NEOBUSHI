extends Area2D

var speed = 150
var health = 3 
var gem_scene = preload("res://Gem.tscn")
var death_effect_scene = preload("res://DeathEffect.gd") 
var knockback = Vector2.ZERO

# New variable to remember the random color
var enemy_color = Color(1, 1, 1)

func _ready():
	# Define a pool of colors for eye candy variety
	var colors = [
		Color(1, 0.3, 0.3), # Red
		Color(0.3, 1, 0.3), # Green
		Color(0.3, 0.3, 1), # Blue
		Color(1, 1, 0.3),   # Yellow
		Color(1, 0.3, 1),   # Pink
		Color(0.3, 1, 1)    # Cyan
	]
	
	# Pick a random color and apply it
	enemy_color = colors[randi() % colors.size()]
	$Sprite.modulate = enemy_color

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
	
	# Impact Flash: Briefly turns bright white to show they were hit
	$Sprite.modulate = Color(10, 10, 10) 
	yield(get_tree().create_timer(0.1), "timeout")
	
	# Restore the specific color this enemy was assigned in _ready()
	$Sprite.modulate = enemy_color
	
	if health <= 0:
		die()

func die():
	# Instance the particle death effect
	var effect = Node2D.new()
	effect.set_script(death_effect_scene)
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	
	# Tell the CanvasLayer to record the kill
	get_tree().current_scene.get_node("CanvasLayer").add_kill()
	
	# Restored XP Logic: 90% chance for Gem, 0% for health
	var roll = randf()
	if roll < 0.90:
		var gem = gem_scene.instance()
		get_tree().current_scene.add_child(gem)
		gem.global_position = global_position
	
	queue_free()
