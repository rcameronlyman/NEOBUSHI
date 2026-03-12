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
