@icon("res://assets/icons/external/pixel-boy/node_2D/icon_brain.png")
class_name Brain
extends Node

var move_direction = Vector2.ZERO
var look_direction = Vector2.ZERO

func get_move_direction() -> Vector2:
    return move_direction

func get_look_direction() -> Vector2:
    return look_direction
