extends CanvasLayer

# This list matches the variables in your Player script
var available_upgrades = [
	{"name": "Fire Rate", "var": "run_fire_rate_lvl"},
	{"name": "Piercing", "var": "run_pierce_lvl"},
	{"name": "Bouncing", "var": "run_bounce_lvl"},
	{"name": "Split Shot", "var": "run_split_shot_lvl"},
	{"name": "Exploding", "var": "run_exploding_lvl"},
	{"name": "Mega Shell", "var": "run_mega_shell_lvl"}
]

var selected_options = []

func _ready():
	randomize()
	# Show the mouse so you can pick your upgrade
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	setup_menu()

func setup_menu():
	var player = get_tree().current_scene.find_node("Player", true, false)
	var valid_upgrades = []
	
	if player:
		# Check which upgrades are still below level 3
		for upgrade in available_upgrades:
			var current_lvl = player.get(upgrade["var"])
			if current_lvl < 3:
				valid_upgrades.append(upgrade)
	
	# If everything is maxed out, just resume the game
	if valid_upgrades.size() == 0:
		resume_game()
		return

	valid_upgrades.shuffle()
	
	# Pick up to 3 options from the filtered list
	selected_options = []
	for i in range(min(3, valid_upgrades.size())):
		selected_options.append(valid_upgrades[i])
	
	# Update button visibility and text
	update_button($HBoxContainer/Option1, 0)
	update_button($HBoxContainer/Option2, 1)
	update_button($HBoxContainer/Option3, 2)

func update_button(btn, index):
	if index < selected_options.size():
		btn.text = selected_options[index]["name"]
		btn.visible = true
	else:
		btn.visible = false

func _on_Option1_pressed():
	apply_upgrade(0)

func _on_Option2_pressed():
	apply_upgrade(1)

func _on_Option3_pressed():
	apply_upgrade(2)

func apply_upgrade(index):
	var upgrade = selected_options[index]
	var player = get_tree().current_scene.find_node("Player", true, false)
	
	if player:
		# 1. Update the Player's local variable for the UI/Visuals
		var current_lvl = player.get(upgrade["var"])
		player.set(upgrade["var"], current_lvl + 1)
		
		# 2. Specifically update Global for Mega Shell so Bullets see it
		if upgrade["name"] == "Mega Shell":
			Global.upgrade_levels["mega_shell"] = current_lvl + 1
	
	resume_game()

func resume_game():
	# Hide mouse again, unpause, and close menu
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	queue_free()
