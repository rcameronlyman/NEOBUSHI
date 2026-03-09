extends Control

func _on_StartButton_pressed():
	# Launches the main gameplay scene
	get_tree().change_scene("res://World.tscn")

func _on_UpgradesButton_pressed():
	# Switches to the Meta Progression menu
	get_tree().change_scene("res://MetaMenu.tscn")
