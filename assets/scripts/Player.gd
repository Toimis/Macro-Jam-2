class_name Player
extends RigidBody2D

const thrust = 256.0
const side_thrust = thrust / 2.0  # Half power for backward thrust
const max_speed = 512.0
const max_angular_speed = 4.0  # Limit the rotational speed for control

const rotation_torque = 512.0  # Torque applied when rotating

@onready var gun_left = $GunLeft
@onready var gun_right = $GunRight
var rotation_speed = 2.0  # Adjust this value to control how fast it rotates

func _physics_process(delta: float) -> void:
	# Rotate ship with A and D keys
	if Input.is_key_pressed(KEY_A):  # Rotate left
		apply_torque_impulse(-rotation_torque * delta)
	elif Input.is_key_pressed(KEY_D):  # Rotate right
		apply_torque_impulse(rotation_torque * delta)
	
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
	
	# Update gun rotations
	update_gun_rotation(gun_left)
	update_gun_rotation(gun_right)

func update_gun_rotation(gun):
	var mouse_position = get_global_mouse_position()
	var target_angle = (mouse_position - gun.global_position).angle()
	var angle_difference = wrapf(target_angle - rotation, -PI, PI)
	
	# Clamp angle difference to +/- PI / 4
	var max_gun_rotation = PI / 4
	angle_difference = clamp(angle_difference, -max_gun_rotation, max_gun_rotation)
	
	# Smoothly interpolate the gun's rotation towards the target angle
	gun.rotation = lerp_angle(gun.rotation, angle_difference + PI / 2, rotation_speed * get_process_delta_time())


#func _process(delta):
	# Lock the camera's rotation to the player's rotation
	#camera.rotation = self.rotation
