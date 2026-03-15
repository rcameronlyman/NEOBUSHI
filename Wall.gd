extends StaticBody2D

# Signals to tell the Spawner/Director what's happening
signal assault_started
signal wall_breached

export var max_health = 500
onready var current_health = max_health
var has_triggered_assault = false

# We use onready so the game finds the bar as soon as the wall "wakes up"
onready var health_bar = $WallHealthBar

func _ready():
	# 1. Setup the health bar
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_bar.hide() # Keep it hidden until the first shot hits
	
	# 2. Add to the "walls" group so bullets can find it
	add_to_group("walls")

func take_damage(amount):
	if current_health <= 0:
		return
		
	# Show the bar and trigger the swarm on the first hit
	if not has_triggered_assault:
		has_triggered_assault = true
		health_bar.show()
		emit_signal("assault_started")
		# You'll connect this signal to your Spawner later
	
	current_health -= amount
	health_bar.value = current_health
	
	# Impact Flash (same logic as your enemies)
	$Sprite.modulate = Color(10, 10, 10) 
	yield(get_tree().create_timer(0.1), "timeout")
	$Sprite.modulate = Color(1, 1, 1)

	if current_health <= 0:
		die()

func die():
	emit_signal("wall_breached")
	# Logic for debris or explosion can go here
	queue_free()
