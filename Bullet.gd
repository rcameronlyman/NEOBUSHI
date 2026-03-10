extends Area2D

var explosion_scene = preload("res://Explosion.tscn")

var speed = 1300 
var direction = Vector2.RIGHT 
var damage = 1

# --- MEGA SHELL LOGIC ---
var mega_shell_threshold = 20 
var is_mega_shell_unlocked = false

# --- IN-RUN BUFF VARIABLES ---
var pierce_count = 0
var bounce_count = 0

func _ready():
	# 1. Check if the upgrade is unlocked in Global and set threshold
	var level = Global.upgrade_levels.get("mega_shell", 0)
	
	if level >= 1:
		is_mega_shell_unlocked = true
		if level == 1:
			mega_shell_threshold = 20
		elif level == 2:
			mega_shell_threshold = 15
		else:
			mega_shell_threshold = 10
		
	# 2. Visuals
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
		
		# 3. Mega Shell Logic: Increment global counter only if unlocked
		if is_mega_shell_unlocked:
			Global.total_bullets_hit += 1
			if Global.total_bullets_hit >= mega_shell_threshold:
				trigger_explosion()
				Global.total_bullets_hit = 0 # Reset counter
		
		# 4. Handle Piercing
		if pierce_count > 0:
			pierce_count -= 1
			return 
		
		# 5. Handle Bouncing
		if bounce_count > 0:
			bounce_count -= 1
			direction = -direction.rotated(rand_range(-0.5, 0.5))
			return 
			
		queue_free()

func trigger_explosion():
	var expo = explosion_scene.instance()
	get_parent().add_child(expo)
	expo.global_position = global_position
