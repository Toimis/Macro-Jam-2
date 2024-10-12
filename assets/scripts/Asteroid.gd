class_name Asteroid
extends RigidBody2D

var direction: Vector2
var speed: float
var angularSpeed: float
var base_mass: float = 1024

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2( (2.0 * randf() - 1.0) , randf() )
	speed = 256.0 * randf() + 64.0
	linear_velocity = direction.normalized() * speed
	angular_velocity = 4.0 * (2.0 * randf() - 1.0)
	
	var massMultiplier: float = randf() + 0.5
	mass = base_mass * massMultiplier
	global_scale *= massMultiplier


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#global_position += direction * speed * delta
	#global_rotation += angularSpeed * delta


func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding body is another asteroid
#	if body is Asteroid:
#		handle_asteroid_collision(body)
	# Check if the colliding body is the player
	if body is Player:
		handle_player_collision(body)


# func handle_asteroid_collision(other_asteroid: Node2D) -> void:
	

func handle_player_collision(player: Node2D) -> void:
	# Example: Trigger a game over or reduce player's health
	# player.take_damage(asteroid_damage)
	queue_free()  # Destroy the asteroid
