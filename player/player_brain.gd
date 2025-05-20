class_name PlayerBrain
extends Brain

@export_range(0.0, 5.0, 0.25) var max_eye_distance: float = 2.5

var _facing_right: bool = true

var _up_pressed: bool = false
var _down_pressed: bool = false
var _left_pressed: bool = false
var _right_pressed: bool = false

var _eye_distance: float = 0.0

var _power_m1_pressed: bool = false
var _power_m2_pressed: bool = false
var _power_shift_pressed: bool = false
var _power_space_pressed: bool = false


func _to_string() -> String:
    var line1: String = " %s  M1 %d M2 %d eye" % ["u" if _up_pressed else "-", int(_power_m1_pressed), int(_power_m2_pressed)]
    var line2: String = "%s %s Sh %d SP %d %.1f" % ["l" if _left_pressed else "-", "r" if _right_pressed else "-", int(_power_shift_pressed), int(_power_space_pressed), look_direction.x]
    var line3: String = " %s  Facing %s %.1f" % ["d" if _down_pressed else "-", "Rh" if _facing_right else "Lf", look_direction.y]
    return line1 + "\n" + line2 + "\n" + line3

func _unhandled_key_input(event: InputEvent) -> void:
    _calculate_move_direction(event)
    _calculate_key_interaction_intent(event)


func _unhandled_input(event: InputEvent) -> void:
    _calculate_look_direction(event)
    _calculate_mouse_interaction_intent(event)


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


func _calculate_key_interaction_intent(event: InputEvent) -> void:
    if (event.is_action_pressed("p_shift")):
        _power_shift_pressed = true
    elif (event.is_action_released("p_shift")):
        _power_shift_pressed = false
    elif (event.is_action_pressed("p_space")):
        _power_space_pressed = true
    elif (event.is_action_released("p_space")):
        _power_space_pressed = false


func _calculate_mouse_interaction_intent(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if (event.is_action_pressed("p_m1")):
            _power_m1_pressed = true
        elif (event.is_action_released("p_m1")):
            _power_m1_pressed = false
        elif (event.is_action_pressed("p_m2")):
            _power_m2_pressed = true
        elif (event.is_action_released("p_m2")):
            _power_m2_pressed = false


func _calculate_look_direction(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        # Calculate the mouse position in global coordinates
        #   Mouse position is relative to the viewport, from 0,0 to viewport size
        var half_viewport_size: Vector2 = get_viewport().get_visible_rect().size / 2.0
        var camera_global_position: Vector2 = get_viewport().get_camera_2d().global_position
        var global_mouse_position: Vector2 = event.position - half_viewport_size + camera_global_position
        var player_to_mouse_direction: Vector2 = global_mouse_position - owner.global_position
        var player_to_mouse_distance: float = player_to_mouse_direction.length()
        _eye_distance = min(max_eye_distance, max_eye_distance * player_to_mouse_distance / half_viewport_size.y)
        look_direction = player_to_mouse_direction / player_to_mouse_distance


func update_sprites(animation: AnimationPlayer, eye: PlayerEye) -> void:
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

    eye.set_eye_position(look_direction * _eye_distance)
