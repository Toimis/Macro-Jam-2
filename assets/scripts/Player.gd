class_name Player
extends CharacterBody2D

const move_speed = 200.0

func _physics_process(delta: float) -> void:
	velocity.x = 0
	velocity.y = 0
	
	if Input.is_key_pressed(KEY_W):
		velocity.y -= 1
		
	if Input.is_key_pressed(KEY_A):
		velocity.x -= 1
		
	if Input.is_key_pressed(KEY_S):
		velocity.y += 1
		
	if Input.is_key_pressed(KEY_D):
		velocity.x += 1
		
		
	velocity *= move_speed
	move_and_slide()
