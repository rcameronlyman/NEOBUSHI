extends Area2D

var speed = 1300 # Slightly faster for a smaller round
var direction = Vector2.RIGHT 
var damage = 1

# --- IN-RUN BUFF VARIABLES ---
var pierce_count = 0
var bounce_count = 0
var can_explode = false
# No change to existing physics, just adding logic for these later

func _ready():
	# Shrink the bullet to 20% of its original size
	$Sprite.scale = Vector2(0.2, 0.2)
	# Optional: Make it look like a glowing tracer
	$Sprite.modulate = Color(2, 2, 1) 

func _process(delta):
	global_position += direction * speed * delta
	
	if global_position.length() > 5000:
		queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group("enemies"):
		# Trigger your existing damage/gore/knockback
		if area.has_method("take_damage"):
			area.take_damage(damage, global_position)
		
		# 1. Handle Piercing
		if pierce_count > 0:
			pierce_count -= 1
			return # Bullet keeps moving through the enemy
		
		# 2. Handle Bouncing (Only happens after piercing is done)
		if bounce_count > 0:
			bounce_count -= 1
			# Simple bounce: reverse direction with a slight random spread
			direction = -direction.rotated(rand_range(-0.5, 0.5))
			return # Bullet keeps moving
		
		# 3. Handle Explosion (Final act before deletion)
		if can_explode:
			trigger_explosion()
			
		# If no pierce or bounce charges are left, delete the bullet
		queue_free()

func trigger_explosion():
	# We will build the Explosion scene and logic in a later step
	print("Bullet Exploded")
