class_name PlayerBrain
extends Brain

var _up_pressed: bool = false
var _down_pressed: bool = false
var _left_pressed: bool = false
var _right_pressed: bool = false
func _calculate_move_direction(event: InputEvent) -> void:
    if (event.is_action_pressed("p_up")):
        _up_pressed = true
    elif (event.is_action_released("p_up")):
        _up_pressed = false
    elif (event.is_action_pressed("p_down")):
        _down_pressed = true
    elif (event.is_action_released("p_down")):
        _down_pressed = false
    elif (event.is_action_pressed("p_left")):
        _left_pressed = true
    elif (event.is_action_released("p_left")):
        _left_pressed = false
    elif (event.is_action_pressed("p_right")):
        _right_pressed = true
    elif (event.is_action_released("p_right")):
        _right_pressed = false

    move_direction = Vector2.ZERO
    if (_up_pressed):
        move_direction.y -= 1.0
    if (_down_pressed):
        move_direction.y += 1.0
    if (_left_pressed):
        move_direction.x -= 1.0
    if (_right_pressed):
        move_direction.x += 1.0

    move_direction = move_direction.normalized()


func _unhandled_key_input(event: InputEvent) -> void:
    _calculate_move_direction(event)


func _unhandled_input(_event: InputEvent) -> void:
    # Handle mouse input and position
    pass