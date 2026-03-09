extends Area2D

var speed = 1300 # Slightly faster for a smaller round
var direction = Vector2.RIGHT 
var damage = 1

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
		if area.has_method("take_damage"):
			area.take_damage(damage, global_position)
		queue_free()
