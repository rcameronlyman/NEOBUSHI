extends Area2D

var explosion_scene = preload("res://Explosion.tscn")

var speed = 1300 
var direction = Vector2.RIGHT 
var damage = 1

# --- MEGA SHELL LOGIC ---
var mega_shell_threshold = 20 
var is_mega_shell_unlocked = false

# --- EXPLOSIVE ROUNDS LOGIC ---
var explosion_chance = 0.0

# --- IN-RUN BUFF VARIABLES ---
var pierce_count = 0
var bounce_count = 0

func _ready():
	# 1. Mega Shell Setup
	var mega_lvl = Global.upgrade_levels.get("mega_shell", 0)
	if mega_lvl >= 1:
		is_mega_shell_unlocked = true
		if mega_lvl == 1: mega_shell_threshold = 20
		elif mega_lvl == 2: mega_shell_threshold = 15
		else: mega_shell_threshold = 10
	
	# 2. Explosive Rounds Setup (Random chance based on level)
	var expo_lvl = Global.upgrade_levels.get("exploding", 0)
	if expo_lvl == 1: explosion_chance = 0.10
	elif expo_lvl == 2: explosion_chance = 0.20
	elif expo_lvl >= 3: explosion_chance = 0.35
		
	# 3. Visuals
	$Sprite.scale = Vector2(0.2, 0.2)
	$Sprite.modulate = Color(2, 2, 1) 

func _process(delta):
	global_position += direction * speed * delta
	if global_position.length() > 5000:
		queue_free()

# This handles hitting StaticBody2D (like Walls)
func _on_Bullet_body_entered(body):
	if body.is_in_group("walls"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		
		handle_final_impact()

# This handles hitting Area2D (like typical Enemies)
func _on_Bullet_area_entered(area):
	# (Keeping wall check here too just in case you use Area-walls later)
	if area.is_in_group("walls"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
		handle_final_impact()
		return

	if area.is_in_group("enemies"):
		if area.has_method("take_damage"):
			area.take_damage(damage, global_position)
		
		if is_mega_shell_unlocked:
			Global.total_bullets_hit += 1
		
		if pierce_count > 0:
			pierce_count -= 1
			return 
		
		if bounce_count > 0:
			bounce_count -= 1
			direction = -direction.rotated(rand_range(-0.5, 0.5))
			return 
			
		handle_final_impact()

func handle_final_impact():
	var triggered_mega = false
	
	if is_mega_shell_unlocked and Global.total_bullets_hit >= mega_shell_threshold:
		trigger_explosion(1.0)
		Global.total_bullets_hit = 0
		triggered_mega = true
	
	if not triggered_mega and explosion_chance > 0:
		if randf() < explosion_chance:
			trigger_explosion(0.5)
	
	queue_free()

func trigger_explosion(blast_scale):
	var expo = explosion_scene.instance()
	get_parent().add_child(expo)
	expo.global_position = global_position
	expo.scale = Vector2(blast_scale, blast_scale)
