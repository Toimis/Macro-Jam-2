class_name Player
extends RigidBody2D

#@onready var camera = $Camera2D  # Get the Camera2D node

const thrust = 256.0
const side_thrust = thrust / 2.0  # Half power for side and backward thrust
const max_speed = 512.0
const max_angular_speed = 4.0  # Limit the rotational speed for control

const Kp = 512.0  # Proportional gain for torque
const Kd = 512.0  # Derivative gain for torque
const max_torque = 512.0

# Called every frame
func _physics_process(delta: float) -> void:
	# Get the current target angle based on the current mouse position
	var mouse_position = get_global_mouse_position()
	var target_angle = (mouse_position - global_position).angle()
	
	# Calculate the shortest angular distance to the target angle
	var angle_difference = wrapf(target_angle - rotation, -PI, PI)
	
	# Compute torque using PD controller
	var torque = Kp * angle_difference - Kd * angular_velocity
	torque = clamp(torque, -max_torque, max_torque)
	
	# Apply torque impulse
	apply_torque_impulse(torque * delta)
	
	# Limit the angular velocity to prevent excessive spinning
	if abs(angular_velocity) > max_angular_speed:
		angular_velocity = sign(angular_velocity) * max_angular_speed
	
	# Initialize thrust_vector to zero
	var thrust_vector = Vector2.ZERO
	
	# Check for inputs and accumulate thrust_vector
	if Input.is_key_pressed(KEY_W):  # W key
		# Thrust forward
		thrust_vector += Vector2(thrust, 0)
	
	if Input.is_key_pressed(KEY_S):  # S key
		# Thrust backward at half power
		thrust_vector += Vector2(-side_thrust, 0)
	
	if Input.is_key_pressed(KEY_A):  # A key
		# Thrust to the left at half power
		thrust_vector += Vector2(0, -side_thrust)
	
	if Input.is_key_pressed(KEY_D):  # D key
		# Thrust to the right at half power
		thrust_vector += Vector2(0, side_thrust)
	
	# Rotate the thrust_vector to match the ship's rotation
	if thrust_vector != Vector2.ZERO:
		thrust_vector = thrust_vector.rotated(rotation)
		
		# Implement the logic to adjust thrust_vector if speed > max_speed
		var speed = linear_velocity.length()
		if speed > max_speed:
			# Compute the component of thrust_vector in the direction of linear_velocity
			var velocity_direction = linear_velocity.normalized()
			var thrust_in_velocity_direction = thrust_vector.project(velocity_direction)
			
			# Check if the thrust would further increase speed
			var dot_product = thrust_vector.dot(velocity_direction)
			if dot_product > 0:
				# Remove the component of thrust in the direction of velocity
				thrust_vector -= thrust_in_velocity_direction
		
		# Apply the adjusted thrust_vector
		apply_central_impulse(thrust_vector * delta)
		

#func _process(delta):
	# Lock the camera's rotation to the player's rotation
	#camera.rotation = self.rotation
