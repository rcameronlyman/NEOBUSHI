extends Node

# --- RUN DATA ---
var gems_collected = 0
var total_bullets_hit = 0
var last_round_win = false # Tracks if the player won or lost the last run

# --- PERMANENT BANK ---
var total_meta_xp = 0.0
var save_path = "user://test_save.dat"

# --- PERSISTENT UPGRADES (Levels) ---
var upgrade_levels = {
	"max_health": 0,
	"armor": 0,
	"move_speed": 0,
	"fire_rate": 0,
	"damage": 0,
	"pickup_range": 0,
	"mega_shell": 0,
}

func _ready():
	load_game()
	total_meta_xp = 5000.0 # TEMP: Force XP for testing

func save_game():
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		var data = {
			"total_meta_xp": total_meta_xp,
			"upgrade_levels": upgrade_levels
		}
		file.store_var(data)
		file.close()
		print("Game Saved. Total Meta XP: ", total_meta_xp)

func load_game():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var data = file.get_var()
			total_meta_xp = data.get("total_meta_xp", 0.0)
			
			var loaded_upgrades = data.get("upgrade_levels", {})
			for stat in upgrade_levels.keys():
				if loaded_upgrades.has(stat):
					upgrade_levels[stat] = loaded_upgrades[stat]
			
			file.close()
			print("Game Loaded. Total Meta XP: ", total_meta_xp)

# This function adds earned XP and saves it
func add_meta_xp(gems):
	var earned = gems * 0.25
	total_meta_xp += earned
	save_game()

# --- MECHANICAL SPENDING LOGIC ---
func attempt_purchase(stat_name, cost, max_level):
	# Now uses the max_level passed from the button press
	if total_meta_xp >= cost and upgrade_levels[stat_name] < max_level:
		total_meta_xp -= cost
		upgrade_levels[stat_name] += 1
		save_game()
		return true # Purchase successful
	else:
		return false # Not enough XP or already at Max Level

# --- TESTING TOOLS ---
func reset_game_data():
	var dir = Directory.new()
	if dir.file_exists(save_path):
		dir.remove(save_path)
		print("Save file deleted.")
	
	# Reset live variables to default values
	total_meta_xp = 0.0
	for stat in upgrade_levels.keys():
		upgrade_levels[stat] = 0
	
	# Reload current scene to refresh the UI immediately
	get_tree().reload_current_scene()
