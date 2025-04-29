class_name VelocityComponent
extends Node

@export var velocity_limit : float = 300.0 # maximum velocity in pixels/sec
@export var acceleration : float = 1500.0 # pixels/sec^2
@export var dynamic_friction : float = 3.0 # deceleration in %/sec (1 means 100%/s)
@export var static_friction : float = 300.0 # deceleration in pixels/sec^2

var m_velocity : Vector2
var m_direction : Vector2


func _ready() -> void:
    m_velocity = Vector2.ZERO
    m_direction = Vector2.ZERO
    assert(acceleration > static_friction, "Friction should not be greater than acceleration—it doesn't make sense.")


func _process(delta: float) -> void:
    # Apply friction to both components
    m_velocity = Vector2(_add_friction(m_velocity.x, delta), _add_friction(m_velocity.y, delta))

    # Accelerate if there is a direction input
    if !m_direction.is_zero_approx():
        m_velocity += m_direction.normalized() * (acceleration * delta)

    # Clamp velocity within limits
    m_velocity = m_velocity.limit_length(velocity_limit)


func _add_friction(velocity_component: float, delta: float) -> float:
    var deceleration: float = static_friction * delta

    # Avoids oscilations in velocity when deceleration would invert velocity sign
    if abs(velocity_component) < deceleration:
        return 0.0

    # Apply dynamic and static friction
    velocity_component *= (1.0 - dynamic_friction * delta)
    velocity_component -= sign(velocity_component) * deceleration

    return velocity_component


func set_direction(direction: Vector2) -> void:
    m_direction = direction


func get_velocity() -> Vector2:
    return m_velocity
