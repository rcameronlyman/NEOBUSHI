extends Area2D

var slide_velocity = Vector2.ZERO
var vertical_velocity = 0.0
var gem_gravity = 800.0 
var friction = 0.9
var is_bouncing = true

# Magnet settings
var attract_speed = 600.0
var target_player = null

func _ready():
	randomize()
	var random_angle = rand_range(0, TAU)
	slide_velocity = Vector2(cos(random_angle), sin(random_angle)) * rand_range(50, 150)
	vertical_velocity = -300.0 

func _process(delta):
	# 1. Handle the initial bounce
	if is_bouncing:
		vertical_velocity += gem_gravity * delta
		global_position.y += vertical_velocity * delta
		global_position.x += slide_velocity.x * delta
		global_position.y += slide_velocity.y * delta 
		slide_velocity *= friction
		
		if vertical_velocity > 300: 
			is_bouncing = false
			vertical_velocity = 0
			slide_velocity = Vector2.ZERO
	
	# 2. Handle the Magnet (Attraction)
	# If we haven't found the player yet, keep looking within the range
	if not target_player:
		var player = get_tree().current_scene.find_node("Player", true, false)
		if player:
			var dist = global_position.distance_to(player.global_position)
			if dist < player.pickup_range:
				target_player = player
				is_bouncing = false 

	# 3. Move toward the player if targeted
	if target_player:
		var direction = (target_player.global_position - global_position).normalized()
		global_position += direction * attract_speed * delta

func _on_Gem_area_entered(area):
	# This ensures the gem only deletes when it physically touches the Player body
	if area.name == "Player" or area.is_in_group("player"):
		# Add your XP signal or function call here
		queue_free()
