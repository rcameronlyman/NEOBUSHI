extends Node2D

export(PackedScene) var crate_scene = preload("res://SupplyCrate.tscn")

# 800 crates makes the world feel alive without lagging the game
export var total_crates = 800  
# Setting this to 2500 keeps them in a 5k area around you 
# so you aren't wandering in a desert forever.
export var map_range = 2500   

func _ready():
	randomize()
	spawn_all_crates()

func spawn_all_crates():
	for i in range(total_crates):
		var crate = crate_scene.instance()
		
		# Spawns crates in a tighter circle/square around the center
		var x_pos = rand_range(-map_range, map_range)
		var y_pos = rand_range(-map_range, map_range)
		
		crate.position = Vector2(x_pos, y_pos)
		
		# Adding to THIS node keeps the Remote tree clean
		add_child(crate)
