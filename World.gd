extends Node2D

func _ready():
	# Ensure the mouse is hidden for gameplay immersion
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Center the massive Ground canvas at 0,0
	if has_node("Ground"):
		$Ground.position = Vector2.ZERO
		$Ground.centered = true
		print("Lunar Surface Initialized: 10,000 x 10,000 canvas centered at 0,0.")

func _process(delta):
	# Update the countdown label
	if has_node("CanvasLayer/Label"):
		$CanvasLayer/Label.text = format_time($Timer.time_left)

# Helper function for m:ss format
func format_time(seconds):
	var m = int(seconds) / 60
	var s = int(seconds) % 60
	return str(m) + "m" + str(s).pad_zeros(2) + "s"

func _on_Timer_timeout():
	# Victory: Survived the full duration
	Global.last_round_win = true
	Global.run_completed = true
	Global.add_meta_xp(Global.gems_collected)
	get_tree().change_scene("res://SummaryScreen.tscn")

func game_over():
	# Defeat: Player died
	Global.last_round_win = false
	Global.run_completed = false
	Global.add_meta_xp(Global.gems_collected)
	get_tree().change_scene("res://SummaryScreen.tscn")

func _on_NextLevelButton_pressed():
	# Cleanup for scene transitions
	get_tree().paused = false
	Global.total_bullets_hit = 0
	Global.gems_collected = 0
	get_tree().change_scene("res://SummaryScreen.tscn")
