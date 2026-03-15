extends Area2D

enum Type { HEALTH, MAGNET, OVERDRIVE, SPEED }
export(Type) var powerup_type = Type.HEALTH

func _ready():
	# ANALYTICAL FIX: Ensure this is in 'powerups' so Player.gd can 'see' it
	add_to_group("powerups") 
	set_visuals()

func set_visuals():
	match powerup_type:
		Type.HEALTH:
			# If using the good sprite, we reset modulate to white so it looks natural
			$Sprite.modulate = Color.white 
		Type.MAGNET:
			$Sprite.modulate = Color.blue
		Type.OVERDRIVE:
			$Sprite.modulate = Color.red
		Type.SPEED:
			# Visual fix: Set it to Cyan so you can see it on the ground
			$Sprite.modulate = Color.cyan

func apply_powerup(player):
	match powerup_type:
		Type.HEALTH:
			player.heal(25)
		Type.MAGNET:
			player.activate_magnet(5.0) 
		Type.OVERDRIVE:
			player.activate_overdrive(5.0)
		Type.SPEED:
			# Both effects trigger at the same time here
			player.activate_speed_boost(5.0)
			player.activate_invincibility(5.0)
	
	# Item is removed ONLY after the effect is applied
	queue_free()

func _on_PowerUp_area_entered(area):
	# Physical pickup: Only triggers when touching the Player's actual collision body
	if area.name == "Player" or area.is_in_group("player"):
		apply_powerup(area)
