@icon("res://assets/icons/boots.png")
class_name VelocityResource
extends Resource

## Maximum speed in pixels/sec
@export var max_speed: float = 300.0
## Acceleration in pixels/sec^2
@export var acceleration: float = 1500.0
## Deceleration in %/sec (1 means 100%/s)
@export var dynamic_friction: float = 3.0
## Deceleration in pixels/sec^2
@export var static_friction: float = 300.0
