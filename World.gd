extends Node2D

func _process(delta):
	# Update the countdown label every frame
	# int() handles the large 900-second starting point correctly
	$CanvasLayer/Label.text = str(int($Timer.time_left))

func _on_Timer_timeout():
	# 1. Show the victory screen from its new location in the CanvasLayer
	$CanvasLayer/VictoryUI/VictoryOverlay.show()
	
	# 2. Freeze the game logic
	get_tree().paused = true

func _on_NextLevelButton_pressed():
	# 1. Unpause the game so we can interact again
	get_tree().paused = false
	
	# 2. Reset the Mega Shell counter so the next run starts fresh
	Global.total_bullets_hit = 0
	
	# 3. Reload the scene to restart the game
	get_tree().reload_current_scene()
