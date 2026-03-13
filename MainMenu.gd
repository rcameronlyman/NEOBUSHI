extends Control

func _on_StartButton_pressed():
	# Launches the main gameplay scene
	get_tree().change_scene("res://World.tscn")

func _on_UpgradesButton_pressed():
	# Switches to the Meta Progression menu
	get_tree().change_scene("res://MetaMenu.tscn")

func _on_OptionsButton_pressed():
	# Switches to the Options Menu scene for data management
	get_tree().change_scene("res://OptionsMenu.tscn")

func _on_ExitButton_pressed():
	# Safely closes the game application
	get_tree().quit()
