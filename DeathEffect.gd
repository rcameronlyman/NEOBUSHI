extends Node2D

func _ready():
	# Create a simple "burst" of 8 particles using code
	for i in range(8):
		var particle = Sprite.new()
		particle.texture = preload("res://icon.png") # Uses your current sprite
		particle.scale = Vector2(0.2, 0.2)
		particle.modulate = Color(1, 0, 0) # Red "blood" or debris
		add_child(particle)
		
		# Give each particle a random direction and speed
		var angle = rand_range(0, TAU)
		var velocity = Vector2(cos(angle), sin(angle)) * rand_range(200, 400)
		
		# Animate the particle flying out and fading away
		var tween = create_tween()
		tween.tween_property(particle, "global_position", global_position + velocity, 0.5)
		tween.parallel().tween_property(particle, "modulate:a", 0.0, 0.5)
	
	# Clean up the whole effect after 0.6 seconds
	yield(get_tree().create_timer(0.6), "timeout")
	queue_free()
