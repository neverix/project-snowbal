extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var p = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("../text/txt").text.length() > 0:
		$mouth.playing = true
		if !$talk.playing:
			$talk.play()
			$talk.seek(p)
	else:
		$mouth.playing = false
		$mouth.frame = 0
		p = $talk.get_playback_position()
		$talk.stop()
