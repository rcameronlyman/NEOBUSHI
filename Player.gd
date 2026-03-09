extends KinematicBody2D

# --- META PROGRESSION STATS ---
var max_health = 100
var health = 100
var armor = 0            # Flat damage reduction
var healing = 0            # Passive HP regen (per second)
var speed = 250            # Move Speed
var fire_rate = 1.5        # Multiplier for shoot speed
var damage_mult = 1.0      # Multiplier for bullet damage
var pickup_range = 150.0   # Area for magnetic gems
var crit_chance = 0.05     # 5% base chance
var cooldown_red = 0.0     # % reduction for abilities
var xp_growth_rate = 1.0   # Multiplier for XP gained

# --- IN-RUN UPGRADE LEVELS (0-3) ---
var run_fire_rate_lvl = 0
var run_pierce_lvl = 0
var run_bounce_lvl = 0
var run_split_shot_lvl = 0
var run_exploding_lvl = 0
var run_mega_shell_lvl = 0
var run_attract_shell_lvl = 0

# --- UNLOCKABLE ABILITIES (Booleans) ---
var has_dash = false
var has_revival = false
var has_reroll = false
var has_piercing = false

# --- INTERNAL LOGIC ---
var velocity = Vector2.ZERO
var can_take_damage = true
var bullet_scene = preload("res://Bullet.tscn")
var shots_fired_count = 0

# --- XP & LEVELING ---
var experience = 0.0        
var level = 0
var xp_to_next_level = 2
var prev_xp_req = 1

func _ready():
	apply_meta_upgrades()
	update_ui()
	if has_node("GemCollector/CollisionShape2D"):
		$GemCollector/CollisionShape2D.shape.radius = pickup_range

func apply_meta_upgrades():
	max_health += (Global.upgrade_levels["max_health"] * 20)
	health = max_health
	speed += (Global.upgrade_levels["move_speed"] * 25)
	armor += Global.upgrade_levels["armor"]
	fire_rate += (Global.upgrade_levels["fire_rate"] * 0.1)
	damage_mult += (Global.upgrade_levels["damage"] * 0.1)
	pickup_range += (Global.upgrade_levels["pickup_range"] * 20)

func _physics_process(delta):
	move_mech()
	attract_gems(delta)
	update_minigun_visual()
	apply_passive_healing(delta)

func move_mech():
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = input.normalized() * speed
	velocity = move_and_slide(velocity)
	if input.length() > 0:
		$AnimatedSprite.play()
		if input.x != 0:
			$AnimatedSprite.animation = "walk_side"
			$AnimatedSprite.flip_h = input.x < 0
		elif input.y < 0:
			$AnimatedSprite.animation = "walk_up"
		else:
			$AnimatedSprite.animation = "walk_down"
	else:
		$AnimatedSprite.stop()

func update_minigun_visual():
	var target = get_closest_enemy()
	if target:
		$Minigun.look_at(target.global_position)
	else:
		if velocity.length() > 0:
			var target_angle = velocity.angle()
			$Minigun.rotation = lerp_angle($Minigun.rotation, target_angle, 0.1)

func attract_gems(delta):
	var gems = get_tree().get_nodes_in_group("gems")
	for gem in gems:
		var dist = global_position.distance_to(gem.global_position)
		if dist < pickup_range:
			var direction = (global_position - gem.global_position).normalized()
			gem.global_position += direction * 400.0 * delta

func apply_passive_healing(delta):
	if health < max_health and healing > 0:
		health += healing * delta
		health = min(health, max_health)
		update_ui()

func shoot():
	var target = get_closest_enemy()
	if not target:
		return

	shots_fired_count += 1
	var bullet_count = 1
	var spread_angle = 0.18

	if run_split_shot_lvl == 1:
		bullet_count = 2
	elif run_split_shot_lvl == 2:
		bullet_count = 3
	elif run_split_shot_lvl == 3:
		bullet_count = 4
		spread_angle = 0.1

	var base_dir = (target.global_position - $Minigun/MuzzleFlash.global_position).normalized()

	for i in range(bullet_count):
		var bullet = bullet_scene.instance()
		get_parent().add_child(bullet)
		bullet.global_position = $Minigun/MuzzleFlash.global_position
		var offset = (i - (bullet_count - 1) / 2.0) * spread_angle
		bullet.direction = base_dir.rotated(offset).normalized()
		bullet.pierce_count = run_pierce_lvl
		bullet.bounce_count = run_bounce_lvl
		if run_exploding_lvl > 0:
			bullet.can_explode = true
		if run_split_shot_lvl == 3:
			bullet.damage *= 1.2

	flash_muzzle()
	check_special_shells()

func check_special_shells():
	var mega_threshold = 25
	if run_mega_shell_lvl == 1: mega_threshold = 20
	if run_mega_shell_lvl == 2: mega_threshold = 15
	if run_mega_shell_lvl == 3: mega_threshold = 10
	
	if shots_fired_count % mega_threshold == 0 and run_mega_shell_lvl > 0:
		print("Firing Mega Shell")

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
			if dist < min_dist:
				min_dist = dist
				nearest = enemy
	return nearest

func _on_ShootTimer_timeout():
	var run_speed_boost = 1.0
	if run_fire_rate_lvl == 1: run_speed_boost = 1.5
	if run_fire_rate_lvl == 2: run_speed_boost = 1.75
	if run_fire_rate_lvl == 3: run_speed_boost = 2.0
	
	$ShootTimer.wait_time = (0.5 / fire_rate) / run_speed_boost
	shoot()

func _on_GemCollector_area_entered(area):
	if area.is_in_group("gems"):
		experience += 1.0 * xp_growth_rate
		Global.gems_collected += 1
		check_level_up()
		area.queue_free()

func check_level_up():
	update_ui()
	if experience >= xp_to_next_level:
		level_up()

func level_up():
	level += 1
	experience = 0
	var next_req = xp_to_next_level + prev_xp_req
	prev_xp_req = xp_to_next_level
	xp_to_next_level = next_req
	update_ui()
	
	# --- Trigger the Upgrade Menu ---
	var menu = load("res://LevelUpMenu.tscn").instance()
	get_tree().current_scene.add_child(menu)
	get_tree().paused = true

func update_ui():
	var xp_bar = get_tree().current_scene.find_node("ExperienceBar", true, false)
	if xp_bar:
		xp_bar.max_value = xp_to_next_level
		xp_bar.value = experience
	var lvl_label = get_tree().current_scene.find_node("LevelLabel", true, false)
	if lvl_label:
		lvl_label.text = "LEVEL: " + str(level)
	var hp_bar = get_tree().current_scene.find_node("HealthBar", true, false)
	if hp_bar:
		hp_bar.max_value = max_health
		hp_bar.value = health

func _on_DetectionArea_area_entered(area):
	if area.is_in_group("enemies") and can_take_damage:
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
				Global.add_meta_xp(Global.gems_collected)
				Global.gems_collected = 0 
				get_tree().change_scene("res://MetaMenu.tscn")
