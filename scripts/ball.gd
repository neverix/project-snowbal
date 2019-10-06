extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 6
export var jump_strength = 300
var size = 1.0
var stopped = false
var parent = null
var shape = null
export var far_distance = 600

func _ready():
	shape = $CollisionShape2D.shape
	parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shape.radius = size
	if stopped:
		return
	if position.x < -far_distance or check_ball_col_smol():
		if len(get_colliding_bodies()) > 0:
			if !stopped:
				var crush = (!check_ball_col()) and (!parent.first)
				if crush:
					parent.crush()
					return
				if len(parent.balls) >= 3:
					get_node("../../../end").play("end")
					return
				stopped = true
				mode = MODE_STATIC
				parent.get_node("../../char/animation").play("throw2")
				parent.get_node("../../char/animation").seek(0.59, true)
		return
	if !stopped and len(get_colliding_bodies()) > 0:
		if linear_velocity.y > 0.0001:
			size += delta * speed
			update()
		if Input.is_action_just_pressed("jump"):
			start_jump()
	if !stopped:
		if Input.is_action_just_released("jump"):
			end_jump()

func start_jump():
	linear_velocity.y = -jump_strength
	$AudioStreamPlayer2D.play()

func end_jump():
	if linear_velocity.y < -jump_strength*0.6:
		linear_velocity.y = -jump_strength*0.6

func check_ball_col():
	if not check_ball_col_smol():
		return false
	for body in parent.balls:
		if body.position.y < position.y:
			return false
	if len(parent.balls) > 1:
		var ball = parent.balls[len(parent.balls) - 2]
		if get_colliding_bodies()[0] != ball:
			return false
		if abs(position.x - ball.position.x) > ball.size * 0.66:
			return false
	return true

func check_ball_col_smol():
	for body in get_colliding_bodies():
		if body.is_in_group("ball"):
			return true
	return false

func _draw():
	draw_circle(Vector2(0, 0), size,
		Color(195.0/255.0, 214.0/255.0, 219.0/255.0))


