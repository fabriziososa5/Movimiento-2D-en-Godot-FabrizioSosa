extends CharacterBody2D

var speed = 200
var acceleration = 900
var friction = 700

var gravity = 900

var jump_force = -350
var max_jumps = 2
var jumps_left = 2

var dash_speed = 600
var dash_time = 0.15
var dash_timer = 0
var can_dash = true
var dash_direction = Vector2.ZERO

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = max_jumps
		can_dash = true

	var direction = Input.get_axis("ui_left", "ui_right")

	if dash_timer <= 0:
		if direction != 0:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y = jump_force
		jumps_left -= 1

	if Input.is_action_just_pressed("ui_select") and can_dash:
		can_dash = false
		dash_timer = dash_time
		
		var input_dir = Vector2(
			Input.get_axis("ui_left", "ui_right"),
			Input.get_axis("ui_up", "ui_down")
		)
		
		if input_dir == Vector2.ZERO:
			input_dir = Vector2.RIGHT if velocity.x >= 0 else Vector2.LEFT
		
		dash_direction = input_dir.normalized()
		velocity = dash_direction * dash_speed

	if dash_timer > 0:
		dash_timer -= delta
		velocity = dash_direction * dash_speed

	move_and_slide()
