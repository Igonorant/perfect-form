class_name State

var _enum_value: int
var _enum_name: StringName
var _about_to_enter: Callable
var _in_state: Callable
var _about_to_exit: Callable

func _init(enum_value: int, enum_name: StringName, about_to_enter: Callable, in_state: Callable, about_to_exit: Callable) -> void:
    _enum_value = enum_value
    _enum_name = enum_name
    _about_to_enter = about_to_enter
    _in_state = in_state
    _about_to_exit = about_to_exit

func _to_string() -> String:
    var return_str: String = "{enum_name}({enum_value})"
    return return_str.format([["enum_name", _enum_name], ["enum_value", _enum_value]]);