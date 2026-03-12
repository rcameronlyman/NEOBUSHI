extends Area2D

var slide_velocity = Vector2.ZERO
var vertical_velocity = 0.0
var gem_gravity = 800.0 
var friction = 0.9
var is_bouncing = true

# Magnet settings
var attract_speed = 600.0

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
	# We find the player in the scene
	var player = get_tree().current_scene.find_node("Player", true, false)
	if player:
		var dist = global_position.distance_to(player.global_position)
		# Only attract if the player is within their specific pickup_range
		if dist < player.pickup_range:
			is_bouncing = false # Stop bouncing if we start attracting
			var direction = (player.global_position - global_position).normalized()
			global_position += direction * attract_speed * delta
