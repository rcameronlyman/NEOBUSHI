extends Control

func _ready():
	# 1. Ensure the menu is hidden when the game starts
	hide()
	
	# 2. Set pause mode to Process so this node still works while game is frozen
	pause_mode = PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("ui_cancel"): # The ESC key
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	
	# 3. Toggle visibility based on the pause state
	visible = new_pause_state
	
	if new_pause_state:
		# Force mouse to show when the menu is active
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		# Hide it again when you go back to the game
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_ResumeButton_pressed():
	toggle_pause()

func _on_EndRunButton_pressed():
	get_tree().paused = false
	# Tell Global that we chose to end this run manually
	Global.run_ended_early = true
	# Bank the XP
	Global.add_meta_xp(Global.gems_collected)
	# Direct path to your root file
	get_tree().change_scene("res://SummaryScreen.tscn")

func _on_RestartButton_button_up():
	get_tree().paused = false
	# Reset gems and reload current scene
	Global.gems_collected = 0
	get_tree().reload_current_scene()

func _on_QuitButton_pressed():
	get_tree().paused = false
	# Reset gems and return to Main Menu
	Global.gems_collected = 0
	# Direct path to your root file
	get_tree().change_scene("res://MainMenu.tscn")
