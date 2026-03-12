extends Control

# This script handles the Options Menu logic, including data management.

func _ready():
	# Ensure the menu reflects the current state when opened
	update_options_ui()

func update_options_ui():
	# You can add logic here later for volume sliders or toggles
	pass

# This is the signal connected to your ResetButton
func _on_ResetButton_pressed():
	# Calls the reset function we just added to Global.gd
	Global.reset_game_data()
	
	# Optional: Visual feedback that it worked
	print("Data has been wiped and scene reloaded.")

func _on_BackButton_pressed():
	# Returns the player to the Main Menu
	get_tree().change_scene("res://MainMenu.tscn")
