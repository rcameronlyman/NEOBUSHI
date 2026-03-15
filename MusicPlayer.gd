extends AudioStreamPlayer

# 1. Define the list of songs
var playlist = [
	preload("res://Sounds/MAIN.mp3"),
	preload("res://Sounds/BadBot.mp3"),
	preload("res://Sounds/ChromeSaints.mp3"),
	preload("res://Sounds/Deep.mp3"),
	preload("res://Sounds/RustedPulseCathedral.mp3")
]

var shuffled_indices = []
var current_track_index = 0

func _ready():
	# randomize() ensures the shuffle is different every time you launch the game
	randomize()
	# Create the shuffled order immediately
	shuffle_playlist()
	
	connect("finished", self, "_on_finished")
	play_current_track()

func shuffle_playlist():
	shuffled_indices = []
	# Fill the array with numbers 0 to 4
	for i in range(playlist.size()):
		shuffled_indices.append(i)
	
	# Shuffle the numbers (e.g., [0,1,2,3,4] becomes [2,4,0,3,1])
	shuffled_indices.shuffle()
	current_track_index = 0
	print("Playlist Shuffled: ", shuffled_indices)

func play_current_track():
	# Use the shuffled index to pick the song
	var song_to_play = shuffled_indices[current_track_index]
	stream = playlist[song_to_play]
	play()
	print("Now playing: ", stream.resource_path)

func _on_finished():
	current_track_index += 1
	
	# If we finished the whole shuffled list, reshuffle and start over
	if current_track_index >= shuffled_indices.size():
		shuffle_playlist()
		
	play_current_track()
