extends Control

func _ready():
	# 1. Force the mouse cursor to show up
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# 2. Set the Win/Loss Message based on the Global state
	if Global.run_ended_early:
		$VBoxContainer/ResultLabel.text = "RUN ENDED - NO COMPLETION BONUS"
		$VBoxContainer/ResultLabel.modulate = Color(1, 1, 0) # Yellow/Gold for manual end
	elif Global.last_round_win:
		$VBoxContainer/ResultLabel.text = "VICTORY"
		$VBoxContainer/ResultLabel.modulate = Color(0, 1, 0) # Green for win
	else:
		$VBoxContainer/ResultLabel.text = "DEFEAT"
		$VBoxContainer/ResultLabel.modulate = Color(1, 0, 0) # Red for loss
	
	# 3. Update labels with run results
	$VBoxContainer/GemsLabel.text = "GEMS COLLECTED: " + str(Global.gems_collected)
	$VBoxContainer/MetaXPLabel.text = "TOTAL META XP: " + str(Global.total_meta_xp)
	
	# 4. Reset the flag so future runs don't default to "Run Ended"
	Global.run_ended_early = false

func _on_HangarButton_pressed():
	Global.gems_collected = 0
	get_tree().paused = false 
	get_tree().change_scene("res://MainMenu.tscn")
