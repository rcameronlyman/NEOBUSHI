extends Control

func _ready():
	# Update the labels using the exact variable names from Global.gd
	$VBoxContainer/GemsLabel.text = "GEMS COLLECTED: " + str(Global.gems_collected)
	$VBoxContainer/MetaXPLabel.text = "TOTAL META XP: " + str(Global.total_meta_xp)

func _on_RetryButton_pressed():
	# Reset the run-specific gems and return to the main game
	Global.gems_collected = 0
	get_tree().change_scene("res://World.tscn")
