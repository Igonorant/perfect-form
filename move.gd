@icon("res://assets/icons/external/pixel-boy/node_2D/icon_path_follow.png")
class_name Move
extends Node

var _max_speed: float
var _acceleration: float
var _static_friction: float
var _dynamic_friction: float

func _to_string() -> String:
    return "Move: max_speed: %f, acceleration: %f, static_friction: %f, dynamic_friction: %f" % [
        _max_speed, _acceleration, _static_friction, _dynamic_friction
    ]

func load(status: StatusRes) -> void:
    _max_speed = status.max_speed

    if (status.acceleration_time < 0.01):
        _acceleration = INF
    else:
        _acceleration = _max_speed / status.acceleration_time

    if (status.deceleration_time < 998.0):
        # By using sqrt(2) we have a smooth motion respecting the deceleration time
        _static_friction = 0.7071 * _max_speed / status.deceleration_time
        _dynamic_friction = 0.7071 / status.deceleration_time
    else:
        _static_friction = 0.0
        _dynamic_friction = 0.0

func execute(body: CharacterBody2D, direction: Vector2, delta: float) -> void:
    # If acceleration is infinity, we can just lock the max speed to the direction
    if (_acceleration == INF):
        assert(direction.is_normalized(), "Direction should always be normalized")
        body.velocity = direction * _max_speed
        body.move_and_slide()
        return

    # Apply friction to both components
    body.velocity = Vector2(_add_friction(body.velocity.x, delta), _add_friction(body.velocity.y, delta))

    # Accelerate if there is a direction input
    if (!direction.is_zero_approx()):
        assert(direction.is_normalized(), "Direction should always be normalized")
        body.velocity += direction * _acceleration * delta

    # Clamp velocity within limits
    body.velocity = body.velocity.limit_length(_max_speed)

    body.move_and_slide()


func _add_friction(velocity_axis: float, delta: float) -> float:
    var velocity_decrement: float = _static_friction * delta

    # Avoids oscillations in velocity when deceleration would invert velocity sign
    if abs(velocity_axis) < velocity_decrement:
        return 0.0

    # Apply dynamic and static friction
    velocity_axis *= (1.0 - _dynamic_friction * delta)
    velocity_axis -= sign(velocity_axis) * velocity_decrement

    return velocity_axis
