extends CharacterBody2D

class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 150.0
@export var jump_velocity = -250.0
@export var gravity = 400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump(jump_velocity)
	# Handle movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	update_animations(direction)
	
func update_animations(direction):
	# Animations to run & idle
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	# Animations to jump & fall
	else:
		# Check negative vertical velocity to play jump animation 
		# and not overwrite with fall animation
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

func jump(jump_velocity):
	velocity.y = jump_velocity
