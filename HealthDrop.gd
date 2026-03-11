extends Area2D

var slide_velocity = Vector2.ZERO
var vertical_velocity = 0.0
var drop_gravity = 800.0 
var friction = 0.9
var is_bouncing = true

var heal_amount = 25 

func _ready():
	randomize()
	# This gives it that random "pop" sideways when it spawns
	var random_angle = rand_range(0, TAU)
	slide_velocity = Vector2(cos(random_angle), sin(random_angle)) * rand_range(50, 150)
	
	# This pops it "up" into the air
	vertical_velocity = -300.0 

func _process(delta):
	if is_bouncing:
		# Apply gravity to the "up/down" movement
		vertical_velocity += drop_gravity * delta
		global_position.y += vertical_velocity * delta
		
		# Apply the horizontal slide
		global_position.x += slide_velocity.x * delta
		global_position.y += slide_velocity.y * delta 
		
		# Slowly stop the sliding
		slide_velocity *= friction
		
		# Once it falls far enough, stop the bounce
		if vertical_velocity > 300: 
			is_bouncing = false
			vertical_velocity = 0
			slide_velocity = Vector2.ZERO

func _on_HealthDrop_area_entered(area):
	# Check if the thing that touched the crate is the Player
	if area.name == "Player" or area.is_in_group("player"):
		# Check if the Player has a "heal" function before we call it
		if area.has_method("heal"):
			area.heal(heal_amount)
			queue_free() # Remove the health crate from the game


func _on_HealthDrop_body_entered(body):
	# Since it's a body_entered signal, the variable is now called 'body'
	if body.name == "Player" or body.is_in_group("player"):
		if body.has_method("heal"):
			body.heal(heal_amount)
			queue_free()
