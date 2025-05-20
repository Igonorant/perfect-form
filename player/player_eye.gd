@icon("res://assets/icons/external/pixel-boy/node_2D/icon_visibility.png")
class_name PlayerEye
extends Node2D


@onready var _eye_sprite: Sprite2D = %PlayerEyeSprite

func _to_string() -> String:
    return "pos %.2f %.2f" % [_eye_sprite.position.x, _eye_sprite.position.y]

func set_eye_position(eye_position: Vector2) -> void:
    _eye_sprite.position = eye_position
