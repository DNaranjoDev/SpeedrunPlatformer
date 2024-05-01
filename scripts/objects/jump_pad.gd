extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var jump_velocity = -400

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		animated_sprite.play("jump")
		body.jump(jump_velocity)
