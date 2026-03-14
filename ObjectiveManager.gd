extends CanvasLayer

var kills_needed = 200
var current_kills = 0
var is_finished = false

func add_kill():
	if is_finished:
		return
		
	current_kills += 1
	print("Kills: ", current_kills)
	
	if current_kills >= kills_needed:
		is_finished = true
		objective_complete()
		
func objective_complete():
	$ObjectiveLabel.text = "OBJECTIVE COMPLETE"
	# We play the animation, which handles the drop, the 5s wait, and the fade
	$ObjectiveLabel/AnimationPlayer.play("ObjectiveDrop")
