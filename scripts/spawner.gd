extends Node2D

export var spawn_force = Vector2(-20, -10)
onready var ball = preload("res://scenes/ball.tscn")
onready var particles = preload("res://scenes/ball_crush.tscn")
var first = true
var balls = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func spawn_first():
	Engine.time_scale = 2
	get_node("../../snow").speed_scale = 0.5
	get_node("../../char/mouth").speed_scale = 0.5
	get_node("../../char/animation").playback_speed = 0.5
	get_node("../../char/back").speed_scale = 0.5
	spawn_next()
	first = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_next():
	var inst = ball.instance()
	var sh = inst.get_node("CollisionShape2D")
	sh.shape = sh.shape.duplicate(true)
	add_child(inst)
	inst.request_ready()
	inst.apply_central_impulse(spawn_force)
	first = false
	balls.append(inst)

func crush():
	for ball in balls:
		var inst = particles.instance()
		add_child(inst)
		inst.request_ready()
		inst.position = ball.position
		inst.emission_sphere_radius = ball.size
		inst.emitting = true
		inst.one_shot = true
		ball.free()
	balls = []
	get_node("../../text/txt").text = "uh oh!"
	var t = Timer.new()
	t.wait_time = 3
	t.one_shot = true
	t.connect("timeout", self, "empty_text")
	add_child(t)
	t.start()
	$crush.play()

func empty_text():
	get_node("../../text/txt").text = ""
	get_node("../../char/animation").play("throw")
	get_node("../../char/animation").seek(0.59, true)

