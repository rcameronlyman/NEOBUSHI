extends Control

func _ready():
	# Forces the menu to be hidden and the game to run when the scene first loads
	visible = false
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"): # This is "Esc" by default in Godot
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
	
	# If we are unpausing, make sure the mouse stays hidden if needed
	if not new_pause_state:
		# Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
		pass

func _on_ResumeButton_pressed():
	# Explicitly hide the menu and unpause the tree
	visible = false
	get_tree().paused = false
