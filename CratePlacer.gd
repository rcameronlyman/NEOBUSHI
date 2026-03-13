extends Node2D

# 1. Case-Sensitivity Audit: Path must match your file system exactly
export(PackedScene) var crate_scene = preload("res://SupplyCrate.tscn")

export var total_crates = 200  # Adjust for density
export var map_range = 5000   # Based on your 10k x 10k Lunar Surface

func _ready():
	# Ensuring random seeds differ every time the .exe is launched
	randomize()
	spawn_all_crates()

func spawn_all_crates():
	for i in range(total_crates):
		var crate = crate_scene.instance()
		
		# 2. Frame-Rate Independence: This is a one-time position shift
		# Positions crates randomly between -5000 and 5000 on both axes
		var x_pos = rand_range(-map_range, map_range)
		var y_pos = rand_range(-map_range, map_range)
		
		crate.global_position = Vector2(x_pos, y_pos)
		
		# Adding to the root of the World scene
		get_tree().current_scene.call_deferred("add_child", crate)
