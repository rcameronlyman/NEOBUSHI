extends Area2D

var health_drop_scene = preload("res://HealthDrop.tscn")

func _ready():
	add_to_group("enemies")
	add_to_group("crate")
	z_index = 0

# The underscore _amount and _pos allow the bullet to pass 
# data without the script complaining about "unused variables"
func take_damage(_amount = 1, _pos = Vector2.ZERO):
	handle_destruction()

func handle_destruction():
	determine_loot()
	queue_free()

func determine_loot():
	if randi() % 4 == 0:
		var drop = health_drop_scene.instance()
		get_tree().current_scene.call_deferred("add_child", drop)
		drop.global_position = global_position
