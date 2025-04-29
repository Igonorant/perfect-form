extends Node
class_name VelocityComponent

@export var velocity_limit : float = 300 # maximum velocity in pixels/sec
@export var acceleration : float = 1500 # pixels/sec^2
@export var friction : float = 0.05 # pixels/sec^2
var m_velocity : Vector2
var m_direction : Vector2
var m_min_velocity : float

func _ready() -> void:
	m_velocity = Vector2.ZERO
	m_direction = Vector2.ZERO
	m_min_velocity = 0.02 * velocity_limit

func _process(delta: float) -> void:
	# Update velocity based on friction for X and Y components
	m_velocity.x = _add_friction(m_velocity.x)
	m_velocity.y = _add_friction(m_velocity.y)
	
	# If there is any direction, accelerate
	if (!m_direction.is_zero_approx()):
		m_velocity += m_direction.normalized() * (acceleration * delta)
		m_velocity = m_velocity.clampf(-velocity_limit, velocity_limit)

# Add friction based on current velocity.
# If it is less than 2% of the velocity limit, make it 0 to avoid going closer and closer to 0
func _add_friction(velocity_component: float) -> float:
	if (abs(velocity_component) < m_min_velocity):
		return 0.0
	else:
		velocity_component -= velocity_component * friction
		return velocity_component

func set_direction(direction: Vector2) -> void:
	m_direction = direction

func get_velocity() -> Vector2:
	return m_velocity
