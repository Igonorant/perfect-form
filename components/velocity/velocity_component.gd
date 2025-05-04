@icon("res://assets/icons/boots.png")
class_name VelocityComponent
extends Node

## Maximum speed in pixels/sec
@export_range(0.0, 2000.0, 1.0, "or_greater", "suffix:pixels/seconds") var speed_limit: float = 500.0
## Time in seconds to reach the maximum speed
@export_range(0.01, 5.0, 0.01, "or_greater", "suffix:seconds") var acceleration_time: float = 0.01
## Time in seconds to stop when there is no acceleration, 999 means no deceleration.
## This is used to calculate the static and dynamic friction.
## NOTE: Instead of 999 it should be INF, but using INF does not work well in the editor
@export_range(0.01, 5.0, 0.01, "or_greater", "suffix:seconds") var deceleration_time: float = 999.0

var _velocity: Vector2
var _direction: Vector2
var _acceleration: float
var _static_friction: float
var _dynamic_friction: float

func _ready() -> void:
    _direction = Vector2.ZERO
    _velocity = Vector2.ZERO

    if (acceleration_time < 0.01):
        _acceleration = INF
    else:
        _acceleration = speed_limit / acceleration_time

    if (deceleration_time < 998.0):
        # By using sqrt(2) we have a smooth motion respecting the deceleration time
        _static_friction = 0.7071 * speed_limit / deceleration_time
        _dynamic_friction = 0.7071 / deceleration_time
    else:
        _static_friction = 0.0
        _dynamic_friction = 0.0

func _physics_process(delta: float) -> void:
    # Apply friction to both components
    _velocity = Vector2(_add_friction(_velocity.x, delta), _add_friction(_velocity.y, delta))

    # Accelerate if there is a direction input
    if !_direction.is_zero_approx():
        assert(_direction.is_normalized(), "Direction should be normalized")
        _velocity += _direction * (_acceleration * delta)

    # Clamp velocity within limits
    _velocity = _velocity.limit_length(speed_limit)


func _add_friction(velocity_axis: float, delta: float) -> float:
    var velocity_decrement: float = _static_friction * delta

    # Avoids oscilations in velocity when deceleration would invert velocity sign
    if abs(velocity_axis) < velocity_decrement:
        return 0.0

    # Apply dynamic and static friction
    velocity_axis *= (1.0 - _dynamic_friction * delta)
    velocity_axis -= sign(velocity_axis) * velocity_decrement

    return velocity_axis


func get_acceleration_direction() -> Vector2:
    return _direction

func set_acceleration_direction(direction: Vector2) -> void:
    if direction.is_zero_approx():
        _direction = Vector2.ZERO
        return

    _direction = direction.normalized()


func get_velocity() -> Vector2:
    return _velocity

func set_velocity(velocity: Vector2) -> void:
    if velocity.is_zero_approx():
        _velocity = Vector2.ZERO
        _direction = Vector2.ZERO
        return

    var velocity_normalized: Vector2 = velocity.normalized()
    _velocity = velocity
    _direction = velocity_normalized
    if _velocity.length() > speed_limit:
        _velocity = velocity_normalized * speed_limit
