@icon("res://assets/icons/boots.png")
class_name VelocityComponent
extends Node

@export var rsrc: VelocityResource

## Current velocity vector in pixels/sec
var _velocity: Vector2 = Vector2.ZERO
## Current direction vector in pixels/sec
var _direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
    # Apply friction to both components
    _velocity.x = _add_friction(_velocity.x, delta)
    _velocity.y = _add_friction(_velocity.y, delta)

    # Accelerate if there is a direction input
    if !_direction.is_zero_approx():
        _velocity += _direction.normalized() * (rsrc.acceleration * delta)

    # Clamp velocity within limits
    _velocity = _velocity.limit_length(rsrc.max_speed)


func _add_friction(velocity_axis: float, delta: float) -> float:
    var velocity_decrement: float = rsrc.static_friction * delta

    # Avoids oscilations in velocity when deceleration would invert velocity sign
    if abs(velocity_axis) < velocity_decrement:
        return 0.0

    # Apply dynamic and static friction
    velocity_axis *= (1.0 - rsrc.dynamic_friction * delta)
    velocity_axis -= sign(velocity_axis) * velocity_decrement

    return velocity_axis


func set_direction(direction: Vector2) -> void: _direction = direction

func get_direction() -> Vector2: return _direction

func set_velocity(velocity: Vector2) -> void: _velocity = velocity

func get_velocity() -> Vector2: return _velocity
