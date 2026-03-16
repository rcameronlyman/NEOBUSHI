extends StaticBody2D

# Signals to tell the Spawner/Director what's happening
signal assault_started
signal wall_breached

export var max_health = 500
onready var current_health = max_health
var has_triggered_assault = false

func _ready():
	# Add to groups so bullets and targeting can find it
	add_to_group("walls")
	add_to_group("enemies")

func take_damage(amount):
	if current_health <= 0:
		return
		
	# Trigger the swarm on the first hit
	if not has_triggered_assault:
		has_triggered_assault = true
		emit_signal("assault_started")
	
	current_health -= amount
	
	# Impact Flash
	$Sprite.modulate = Color(10, 10, 10) 
	yield(get_tree().create_timer(0.1), "timeout")
	$Sprite.modulate = Color(1, 1, 1)

	if current_health <= 0:
		die()

func die():
	emit_signal("wall_breached")
	# Logic for debris or explosion can go here
	queue_free()
