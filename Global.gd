extends Node

# --- RUN DATA ---
var gems_collected = 0

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
	"pickup_range": 0
}

func _ready():
	load_game()

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
			upgrade_levels = data.get("upgrade_levels", upgrade_levels)
			file.close()
			print("Game Loaded. Total Meta XP: ", total_meta_xp)

# This function adds earned XP and saves it
func add_meta_xp(gems):
	var earned = gems * 0.25
	total_meta_xp += earned
	save_game()

# --- MECHANICAL SPENDING LOGIC ---
func attempt_purchase(stat_name, cost):
	if total_meta_xp >= cost:
		total_meta_xp -= cost
		upgrade_levels[stat_name] += 1
		save_game()
		return true # Purchase successful
	else:
		return false # Not enough XP
