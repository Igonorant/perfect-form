class_name PlayerBrain
extends Brain

var _facing_right: bool = true
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
        _facing_right = false
    elif (event.is_action_released("p_left")):
        _left_pressed = false
    elif (event.is_action_pressed("p_right")):
        _right_pressed = true
        _facing_right = true
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


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        # Calculate the mouse position in global coordinates
        #   Mouse position is relative to the viewport, from 0,0 to viewport size
        var half_viewport_size: Vector2 = get_viewport().get_visible_rect().size / 2.0
        var camera_global_position: Vector2 = get_viewport().get_camera_2d().global_position
        var global_mouse_position: Vector2 = event.position - half_viewport_size + camera_global_position
        look_direction = (global_mouse_position - owner.global_position).normalized()

func update_sprites(animation: AnimationPlayer, eye: Sprite2D) -> void:
    if (move_direction.is_zero_approx()):
        if _facing_right:
            animation.play("idle_r")
        else:
            animation.play("idle_l")
    else:
        if _facing_right:
            animation.play("move_r")
        else:
            animation.play("move_l")

    eye.position = look_direction * 2.0
