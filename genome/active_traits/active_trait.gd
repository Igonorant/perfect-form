class_name ActiveTrait
extends Node2D

@export var trait_info: Trait
@export var friendly: bool = true

var _direction: Vector2 = Vector2.ZERO

func set_direction(direction: Vector2) -> void:
    _direction = direction.normalized()
