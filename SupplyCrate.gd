extends Area2D

var health_drop_scene = preload("res://HealthDrop.tscn")
var power_up_scene = preload("res://PowerUp.tscn")

func _ready():
	# Keep your group logic
	add_to_group("enemies")
	add_to_group("crate")
	z_index = 0

func take_damage(_amount = 1, _pos = Vector2.ZERO):
	handle_destruction()

func handle_destruction():
	determine_loot()
	queue_free()

func determine_loot():
	var roll = randi() % 4
	
	# 25% chance to drop the "Good" HealthDrop
	if roll == 0:
		var drop = health_drop_scene.instance()
		get_tree().current_scene.call_deferred("add_child", drop)
		drop.global_position = global_position
	
	# 25% chance to drop a PowerUp (Magnet, Overdrive, or Speed ONLY)
	elif roll == 1:
		var p_up = power_up_scene.instance()
		
		# randi() % 3 + 1 forces the result to be 1, 2, or 3.
		# This skips 0 (HEALTH) so you never see the green logo placeholder again.
		p_up.powerup_type = (randi() % 3) + 1
		
		get_tree().current_scene.call_deferred("add_child", p_up)
		p_up.global_position = global_position
