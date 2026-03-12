extends Control

# Cost array based on your Master Blueprint plan
var upgrade_costs = [10, 25, 50, 100, 250]

func _ready():
	update_ui()

# Refreshes the display for all currency and stats
func update_ui():
	# Update the Currency Display
	$HeaderContainer/XPDisplay.text = "AVAILABLE XP: " + str(int(Global.total_meta_xp))
	
	# Update rows using your specific scene naming
	update_row("max_health", "HealthRow", "Health", 5)
	update_row("move_speed", "SpeedRow", "Speed", 5)
	update_row("armor", "ArmorRow", "Armor", 5)
	update_row("fire_rate", "FireRateRow", "FireRate", 5)
	update_row("damage", "DamageRow", "Damage", 5)
	update_row("pickup_range", "PickupRangeRow", "PickupRange", 5)
	
	# Special case for Mega Shell (1 level max)
	update_row("mega_shell", "MegaShellRow", "MegaShell", 1)

func update_row(stat_key, row_name, prefix, max_lvl):
	var current_lvl = Global.upgrade_levels[stat_key]
	var row = get_node("ScrollContainer/UpgradeList/" + row_name)
	
	# Update Level Label (e.g., Lv: 1/5)
	row.get_node(prefix + "LevelLabel").text = "LV " + str(current_lvl) + "/" + str(max_lvl)
	
	# Update Progress Bar (e.g., SpeedBar)
	var bar = row.get_node(prefix + "Bar")
	bar.max_value = max_lvl
	bar.value = current_lvl
	
	# Update Button text and cost
	var button = row.get_node(prefix + "Button")
	if current_lvl < max_lvl:
		var cost = upgrade_costs[current_lvl]
		button.text = prefix.to_upper() + " (" + str(cost) + "XP)"
		button.disabled = false
	else:
		button.text = "MAXED"
		button.disabled = true

# --- BUTTON SIGNALS ---

func _on_HealthButton_pressed():
	buy_upgrade("max_health", 5)

func _on_SpeedButton_pressed():
	buy_upgrade("move_speed", 5)

func _on_ArmorButton_pressed():
	buy_upgrade("armor", 5)

func _on_FireRateButton_pressed():
	buy_upgrade("fire_rate", 5)

func _on_DamageButton_pressed():
	buy_upgrade("damage", 5)

func _on_PickupRangeButton_pressed():
	buy_upgrade("pickup_range", 5)

func _on_MegaShellButton_pressed():
	buy_upgrade("mega_shell", 1)

func buy_upgrade(stat_key, max_lvl):
	var current_lvl = Global.upgrade_levels[stat_key]
	if current_lvl < max_lvl:
		var cost = upgrade_costs[current_lvl]
		if Global.attempt_purchase(stat_key, cost, max_lvl):
			update_ui()

# This matches the signal connection seen in your screenshot
func _on_Menu_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
