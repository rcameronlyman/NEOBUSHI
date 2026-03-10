extends Area2D

var damage = 2 # Explosions do double the base bullet damage

func _ready():
	# Force the animation to start at the first frame
	$AnimatedSprite.frame = 0
	# Connect the signal so it deletes itself when the animation ends
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$AnimatedSprite.play("default")

func _on_animation_finished():
	# This deletes the explosion scene once the animation ends
	queue_free()

func _on_Explosion_area_entered(area):
	# This checks if an enemy is inside the CircleShape2D radius
	if area.is_in_group("enemies"):
		if area.has_method("take_damage"):
			# Pass damage and position for knockback calculation
			area.take_damage(damage, global_position)
