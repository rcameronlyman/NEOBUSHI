extends Control

onready var xp_label = $XPDisplay

func _ready():
	update_ui()

func update_ui():
	# Updates the label with your saved XP
	xp_label.text = "Available XP: " + str(stepify(Global.total_meta_xp, 0.1))

func _on_HealthButton_pressed():
	if Global.attempt_purchase("max_health", 10):
		update_ui()

func _on_SpeedButton_pressed():
	if Global.attempt_purchase("move_speed", 15):
		update_ui()

func _on_BackButton_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
