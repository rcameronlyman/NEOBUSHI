extends Node2D

func _process(delta):
	# Update the countdown label with formatted time (e.g., 1m34s)
	$CanvasLayer/Label.text = format_time($Timer.time_left)

# Helper function to convert seconds into a m:ss format
func format_time(seconds):
	var m = int(seconds) / 60
	var s = int(seconds) % 60
	# pad_zeros(2) ensures 1 minute 5 seconds looks like 1m05s
	return str(m) + "m" + str(s).pad_zeros(2) + "s"

func _on_Timer_timeout():
	# Victory: Player survived until the end
	Global.last_round_win = true
	
	# Bank the gems before leaving the scene
	Global.add_meta_xp(Global.gems_collected)
	
	# Transition to the Summary Screen
	get_tree().change_scene("res://SummaryScreen.tscn")

func game_over():
	# Defeat: Called from Player.gd when health <= 0
	Global.last_round_win = false
	
	# Still bank the gems collected before death
	Global.add_meta_xp(Global.gems_collected)
	
	# Transition to the Summary Screen
	get_tree().change_scene("res://SummaryScreen.tscn")

func _on_NextLevelButton_pressed():
	# Standard cleanup for moving between menus
	get_tree().paused = false
	Global.total_bullets_hit = 0
	Global.gems_collected = 0
	get_tree().change_scene("res://SummaryScreen.tscn")
