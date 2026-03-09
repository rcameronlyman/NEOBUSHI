extends Area2D

var slide_velocity = Vector2.ZERO
var vertical_velocity = 0.0
var gem_gravity = 800.0 # Renamed to avoid the error
var friction = 0.9
var is_bouncing = true

func _ready():
	randomize()
	
	# 1. Random side-to-side slide
	var random_angle = rand_range(0, TAU)
	slide_velocity = Vector2(cos(random_angle), sin(random_angle)) * rand_range(50, 150)
	
	# 2. Initial "Up" burst (Negative Y is up in Godot)
	vertical_velocity = -300.0 

func _process(delta):
	if is_bouncing:
		# Apply renamed gravity to the vertical movement
		vertical_velocity += gem_gravity * delta
		global_position.y += vertical_velocity * delta
		
		# Apply the horizontal slide
		global_position.x += slide_velocity.x * delta
		global_position.y += slide_velocity.y * delta 
		
		# Slow down the slide over time
		slide_velocity *= friction
		
		# If it falls past its "landing point" (simulated), stop the bounce
		if vertical_velocity > 300: 
			is_bouncing = false
			vertical_velocity = 0
			slide_velocity = Vector2.ZERO

func _on_Gem_body_entered(body):
	if body.name == "Player":
		queue_free()
