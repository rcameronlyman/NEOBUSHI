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

func _on_Bullet_area_entered(area):
	if area.is_in_group("enemies"):
		if area.has_method("take_damage"):
			area.take_damage(damage, global_position)
		
		# 1. Increment Mega Shell counter on every hit, even if it pierces
		if is_mega_shell_unlocked:
			Global.total_bullets_hit += 1
		
		# 2. Handle Piercing (Exits function, bullet stays alive)
		if pierce_count > 0:
			pierce_count -= 1
			return 
		
		# 3. Handle Bouncing (Exits function, bullet stays alive)
		if bounce_count > 0:
			bounce_count -= 1
			direction = -direction.rotated(rand_range(-0.5, 0.5))
			return 
			
		# 4. FINAL IMPACT LOGIC (The bullet is dying now)
		var triggered_mega = false
		
		# Check Mega Shell first (Guaranteed)
		if is_mega_shell_unlocked and Global.total_bullets_hit >= mega_shell_threshold:
			trigger_explosion(1.0) # Full scale
			Global.total_bullets_hit = 0
			triggered_mega = true
		
		# Check Explosive Rounds (Random chance, only if Mega didn't fire)
		if not triggered_mega and explosion_chance > 0:
			if randf() < explosion_chance:
				trigger_explosion(0.5) # Half scale "mini-blast"
		
		queue_free()

func trigger_explosion(blast_scale):
	var expo = explosion_scene.instance()
	get_parent().add_child(expo)
	expo.global_position = global_position
	expo.scale = Vector2(blast_scale, blast_scale)
