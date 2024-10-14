class_name Asteroid
extends RigidBody2D

var base_mass: float = 512

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Enable contact monitoring for collision detection
	contact_monitor = true
	max_contacts_reported = 8
	
	# Set initial velocity using direction and speed
	var speed: float = 128.0 * randf() + 64.0  # Gives a range between 64 and 128
	var direction: Vector2 = Vector2((2.0 * randf() - 1.0), (2.0 * randf() - 1.0)).normalized()
	linear_velocity = direction * speed
	
	# Set initial angular velocity
	angular_velocity = 4.0 * (2.0 * randf() - 1.0)
	
	# Set mass and scale based on massMultiplier
	var massMultiplier: float = randf() + 1.0
	mass = base_mass * massMultiplier
	
	# Scale the asteroid using the custom function
	scale_asteroid(massMultiplier)

# Collision handling
func _on_body_entered(body: Node2D) -> void:
	# Check if the colliding body is the player
	if body is Player:
		handle_player_collision(body)

# Handle player collision
func handle_player_collision(player: Node2D) -> void:
	# Try to disable the CollisionPolygon2D
	var collision_shape = $CollisionPolygon2D
	
	if collision_shape != null:
		collision_shape.disabled = true
	
	# Wait for 0.1 seconds before destroying the asteroid
	await get_tree().create_timer(0.125).timeout
	
	queue_free()
	
# Scales polygons in the components
func scale_asteroid(factor):
	# Scale the visual sprite
	var sprite = $Sprite2D
	if sprite:
		sprite.scale *= factor

	# Scale the CollisionPolygon2D attached to the RigidBody2D
	var collision_shape = $CollisionPolygon2D
	if collision_shape:
		var polygon = collision_shape.polygon
		for i in range(polygon.size()):
			polygon[i] *= factor
		collision_shape.polygon = polygon

	# Scale the CollisionPolygon2D inside Area2D
	var area_collision_shape = $Area2D/CollisionPolygon2D
	if area_collision_shape:
		var area_polygon = area_collision_shape.polygon
		for i in range(area_polygon.size()):
			area_polygon[i] *= factor
		area_collision_shape.polygon = area_polygon
