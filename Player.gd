extends KinematicBody2D

# --- MOVEMENT CONSTANTS ---
var acceleration = 800  
var friction = 4000         
var pulse_speed = 0.4       
var rotation_speed = 0.15   

# --- META PROGRESSION STATS ---
var max_health = 100
var health = 100
var armor = 0                
var healing = 0                
var speed = 375            
var fire_rate = 1.5         
var damage_mult = 1.0      
var pickup_range = 150.0   
var crit_chance = 0.05     
var cooldown_red = 0.0     
var xp_growth_rate = .5   

# --- POWER-UP TEMPORARY STATS ---
var boost_speed = 0.0
var boost_fire_rate = 1.0
var magnet_active = false

# --- IN-RUN UPGRADE LEVELS ---
var run_fire_rate_lvl = 0
var run_pierce_lvl = 0
var run_bounce_lvl = 0
var run_split_shot_lvl = 0
var run_exploding_lvl = 1
var run_mega_shell_lvl = 0
var run_attract_shell_lvl = 0

# --- UNLOCKABLE ABILITIES ---
var has_dash = false
var has_revival = false
var has_reroll = false
var has_piercing = false

# --- INTERNAL LOGIC ---
var velocity = Vector2.ZERO
var can_take_damage = true
var bullet_scene = preload("res://Bullet.tscn")

# --- XP & LEVELING ---
var experience = 0.0          
var level = 1                 
var xp_to_next_level = 2
var prev_xp_req = 1

func _ready():
	apply_meta_upgrades()
	update_ui()

func apply_meta_upgrades():
	max_health += (Global.upgrade_levels["max_health"] * 20)
	health = max_health
	speed += (Global.upgrade_levels["move_speed"] * 37.5) 
	armor += Global.upgrade_levels["armor"]
	fire_rate += (Global.upgrade_levels["fire_rate"] * 0.1)
	damage_mult += (Global.upgrade_levels["damage"] * 0.1)
	pickup_range += (Global.upgrade_levels["pickup_range"] * 20)

func _physics_process(delta):
	move_mech(delta)
	update_minigun_visual()
	apply_passive_healing(delta)
	
	for area in $GemCollector.get_overlapping_areas():
		if area.is_in_group("crate") or area.is_in_group("unarmored"):
			if area.has_method("take_damage"):
				area.take_damage(100)

func move_mech(delta):
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input = input.normalized()
	
	if input != Vector2.ZERO:
		var target_speed = speed + boost_speed
		
		if $AnimatedSprite.frame == 0 or $AnimatedSprite.frame == 1:
			target_speed = (speed + boost_speed) * pulse_speed
		
		velocity = velocity.move_toward(input * target_speed, acceleration * delta)
		
		var steps_per_second = 2 + Global.upgrade_levels["move_speed"]
		var total_fps = steps_per_second * 3
		$AnimatedSprite.speed_scale = (total_fps / 5.0) * 0.66
		
		$AnimatedSprite.play()
		if input.x != 0:
			$AnimatedSprite.animation = "walk_side"
			$AnimatedSprite.flip_h = input.x < 0
		elif input.y < 0:
			$AnimatedSprite.animation = "walk_up"
		else:
			$AnimatedSprite.animation = "walk_down"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0 
		$AnimatedSprite.speed_scale = 1.0 
		
	velocity = move_and_slide(velocity)

# --- POWER-UP FUNCTIONS ---

func activate_speed_boost(duration):
	boost_speed = 200.0
	
	# Start the "Stutter" effect
	var effect_timer = 0.0
	while effect_timer < duration:
		# Toggle transparency for that "ghosting" look
		$AnimatedSprite.modulate.a = 0.3
		yield(get_tree().create_timer(0.05), "timeout")
		$AnimatedSprite.modulate.a = 1.0
		yield(get_tree().create_timer(0.05), "timeout")
		effect_timer += 0.1
	
	# Reset after duration
	boost_speed = 0.0
	$AnimatedSprite.modulate.a = 1.0

func activate_overdrive(duration):
	boost_fire_rate = 4.0
	# Intense white-hot glow (RGB values above 1.0)
	$AnimatedSprite.modulate = Color(4, 4, 2) 
	
	yield(get_tree().create_timer(duration), "timeout")
	
	boost_fire_rate = 1.0
	$AnimatedSprite.modulate = Color(1, 1, 1) # Reset to normal

func activate_magnet(duration):
	magnet_active = true
	var original_range = pickup_range
	pickup_range = 1000 
	yield(get_tree().create_timer(duration), "timeout")
	pickup_range = original_range
	magnet_active = false

func heal(amount):
	health += amount
	if health > max_health:
		health = max_health
	update_ui()

# --- REVISED XP & POWERUP COLLECTION ---

func _on_GemCollector_area_entered(area):
	# Analytical Fix: Added 'powerups' group check
	if area.is_in_group("gems") or area.is_in_group("powerups"):
		# 1. Check if it's a Power-up or special item first
		if area.has_method("apply_powerup"):
			area.apply_powerup(self)
			return # Exit to avoid XP logic below

		# 2. Treat as XP Gem
		var dist = global_position.distance_to(area.global_position)
		if dist < 80: 
			experience += 1.0 * xp_growth_rate
			Global.gems_collected += 1
			check_level_up()
			area.queue_free()
	
	if area.is_in_group("crate"):
		if area.has_method("take_damage"):
			area.take_damage(100)

# --- EXISTING LOGIC (Unchanged) ---

func update_minigun_visual():
	var target = get_closest_enemy()
	if target:
		var target_angle = (target.global_position - global_position).angle()
		$Minigun.rotation = lerp_angle($Minigun.rotation, target_angle, rotation_speed)
	else:
		if velocity.length() > 0:
			var move_angle = velocity.angle()
			$Minigun.rotation = lerp_angle($Minigun.rotation, move_angle, rotation_speed * 0.5)

func apply_passive_healing(delta):
	if health < max_health and healing > 0:
		health += healing * delta
		health = min(health, max_health)
		update_ui()

func shoot():
	var target = get_closest_enemy()
	if not target: return

	var bullet_count = 1
	var spread_angle = 0.18
	if run_split_shot_lvl == 1: bullet_count = 2
	elif run_split_shot_lvl == 2: bullet_count = 3
	elif run_split_shot_lvl == 3: bullet_count = 4; spread_angle = 0.1

	var base_dir = (target.global_position - $Minigun/MuzzleFlash.global_position).normalized()
	for i in range(bullet_count):
		var bullet = bullet_scene.instance()
		get_parent().add_child(bullet)
		bullet.global_position = $Minigun/MuzzleFlash.global_position
		var offset = (i - (bullet_count - 1) / 2.0) * spread_angle
		bullet.direction = base_dir.rotated(offset).normalized()
		bullet.pierce_count = run_pierce_lvl
		bullet.bounce_count = run_bounce_lvl
	flash_muzzle()

func flash_muzzle():
	$Minigun/MuzzleFlash.show()
	var s = rand_range(0.8, 1.2)
	$Minigun/MuzzleFlash.scale = Vector2(s, s)
	yield(get_tree().create_timer(0.05), "timeout")
	$Minigun/MuzzleFlash.hide()

func get_closest_enemy():
	var enemies = $ShootingRange.get_overlapping_areas()
	var nearest = null
	var min_dist = INF
	for enemy in enemies:
		if enemy.is_in_group("enemies"):
			var dist = global_position.distance_to(enemy.global_position)
			var effective_dist = dist
			if enemy.is_in_group("crate"):
				var dir_to_target = (enemy.global_position - global_position).normalized()
				var facing_dir = Vector2.RIGHT.rotated($Minigun.rotation)
				var dot = facing_dir.dot(dir_to_target)
				if dot < 0.7 and dist > 120: effective_dist += 4000 
			if effective_dist < min_dist:
				min_dist = effective_dist
				nearest = enemy
	return nearest

func _on_ShootTimer_timeout():
	var run_speed_boost = 1.0
	if run_fire_rate_lvl == 1: run_speed_boost = 1.5
	if run_fire_rate_lvl == 2: run_speed_boost = 1.75
	if run_fire_rate_lvl == 3: run_speed_boost = 2.0
	$ShootTimer.wait_time = (0.5 / fire_rate) / (run_speed_boost * boost_fire_rate)
	shoot()

func check_level_up():
	update_ui()
	if experience >= xp_to_next_level: level_up()

func level_up():
	level += 1
	experience = 0
	var next_req = xp_to_next_level + prev_xp_req
	prev_xp_req = xp_to_next_level
	xp_to_next_level = next_req
	update_ui()
	var menu = load("res://LevelUpMenu.tscn").instance()
	get_tree().current_scene.add_child(menu)
	get_tree().paused = true

func update_ui():
	var xp_bar = get_tree().current_scene.find_node("ExperienceBar", true, false)
	if xp_bar:
		xp_bar.max_value = xp_to_next_level
		xp_bar.value = experience
	var lvl_label = get_tree().current_scene.find_node("LevelLabel", true, false)
	if lvl_label: lvl_label.text = "LEVEL: " + str(level)
	var hp_bar = get_tree().current_scene.find_node("HealthBar", true, false)
	if hp_bar:
		hp_bar.max_value = max_health
		hp_bar.value = health

func _on_DetectionArea_area_entered(area):
	if area.is_in_group("enemies") and can_take_damage:
		if area.is_in_group("crate"): return
		var damage_taken = max(1, 10 - armor) 
		health -= damage_taken
		update_ui()
		can_take_damage = false
		$AnimatedSprite.modulate = Color(5, 1, 1)
		yield(get_tree().create_timer(0.2), "timeout")
		$AnimatedSprite.modulate = Color(1, 1, 1)
		can_take_damage = true
		if health <= 0:
			if has_revival:
				health = max_health / 2
				has_revival = false 
				update_ui()
			else:
				if get_parent().has_method("game_over"): get_parent().game_over()
				else:
					Global.add_meta_xp(Global.gems_collected)
					get_tree().change_scene("res://SummaryScreen.tscn")

func activate_invincibility(duration):
	can_take_damage = false
	# Optional: Make the player see-through to show they are invincible
	modulate.a = 0.5 
	
	yield(get_tree().create_timer(duration), "timeout")
	
	can_take_damage = true
	modulate.a = 1.0 # Back to normal transparency
