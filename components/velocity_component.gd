extends Node
class_name VelocityComponent

@export var velocity_limit : float = 300.0 # maximum velocity in pixels/sec
@export var acceleration : float = 1500.0 # pixels/sec^2
@export var dynamic_friction : float = 3.0 # decceleration in %/sec (1 means 100%/s)
@export var static_friction : float = 300.0 # decceleration in pixels/sec^2
var m_velocity : Vector2
var m_direction : Vector2

func _ready() -> void:
	m_velocity = Vector2.ZERO
	m_direction = Vector2.ZERO
	assert(acceleration > static_friction, "Friction should not be greater than acceleration, it doesn't make sense.")

func _process(delta: float) -> void:
	# Update velocity based on friction for X and Y components
	m_velocity.x = _add_friction(m_velocity.x, delta)
	m_velocity.y = _add_friction(m_velocity.y, delta)
	
	# If there is any direction, accelerate
	if (!m_direction.is_zero_approx()):
		m_velocity += m_direction.normalized() * (acceleration * delta)
		m_velocity = m_velocity.clampf(-velocity_limit, velocity_limit)

# Add friction based on current velocity.
func _add_friction(velocity_component: float, delta: float) -> float:
	var static_friction_delta: float = static_friction * delta
	if abs(velocity_component) < static_friction_delta:
		return 0.0
	# Apply dynamic friction
	velocity_component -= velocity_component * dynamic_friction * delta
	# Apply static friction in the correct direction
	velocity_component -= sign(velocity_component) * static_friction_delta
	return velocity_component


func set_direction(direction: Vector2) -> void:
	m_direction = direction

func get_velocity() -> Vector2:
	return m_velocity
