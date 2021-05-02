extends AudioStreamPlayer

const tracks = [
	'bijan-kia-fardjad_far-away-land-1a.mp3',
	'Town Theme 1.wav',
	'025_A_New_Town.mp3',
	'RPG - The Secret Within The Silent Woods.ogg'
]

func _ready():
# warning-ignore:return_value_discarded
		connect("finished" ,self, "play_random_song")
		play_random_song()

func play_random_song():
	var rand_nb = randi() % tracks.size()
	var audiostream = load("res://Music&Sounds/Music/WorldMusic/"+ tracks[rand_nb])
	set_stream(audiostream)
	play()
