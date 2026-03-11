extends Control

func _ready():
	# Update the labels using the exact variable names from Global.gd
	$VBoxContainer/GemsLabel.text = "GEMS COLLECTED: " + str(Global.gems_collected)
	$VBoxContainer/MetaXPLabel.text = "TOTAL META XP: " + str(Global.total_meta_xp)

func _on_HangarButton_pressed():
	# Reset the run-specific gems so the next run starts at 0
	Global.gems_collected = 0
	
	# CRITICAL: Unpause the tree so the Main Menu can actually run
	get_tree().paused = false 
	
	# This takes you back to your Main Menu (The Hangar)
	# Updated from 'Main.tscn' to 'MainMenu.tscn' to match your file system
	get_tree().change_scene("res://MainMenu.tscn")
