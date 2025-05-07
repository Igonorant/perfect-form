class_name StateMachine
extends State

func _init() -> void:
    pass

var _debug_mode: bool = false
func _set_debug_mode() -> void:
    _debug_mode = true

var _states: Array[State] = []
var _max_enum_value: int = 0
func add_state(state: State) -> void:
    if (_debug_mode):
        print("@FSM adding state: ", state, " | current size: ", _states.size(), " | max enum value: ", _max_enum_value)

    # Ensures states array will accomodate the new state
    if (_states.is_empty()):
        _states.resize(state._enum_value + 1)
    while (_states.size() <= state._enum_value):
        _states.resize(_states.size() * 2)

    _states[state._enum_value] = state
    _max_enum_value = max(_max_enum_value, state._enum_value)

    if (_debug_mode):
        print("@FSM added state: ", state, " | current size: ", _states.size(), " | max enum value: ", _max_enum_value)

func end_adding_states() -> void:
    _states.resize(_max_enum_value + 1)
    if (_debug_mode):
        print("@FSM end adding states | all states: ", _states)


var _locked: bool = false
func lock() -> void:
    if (_debug_mode):
        print("@FSM locking...")
    _locked = true

func unlock() -> void:
    if (_debug_mode):
        print("@FSM unlocking...")
    _locked = false


var _current_state: int = -1
var _previous_state: int = -2
func set_state(state_enum_value: int) -> void:
    assert(state_enum_value < _states.size(), "Trying to set an invalid state")

    if (_locked):
        if (_debug_mode):
            print("@FSM is locked when trying to change to state: ", _states[_current_state])
        return

    if (_current_state == state_enum_value):
        if (_debug_mode):
            print("@FSM trying to change to the same state, skipping... : ", _states[_current_state])
        return

    if (_current_state != -1):
        var previous_state: State = _states[_current_state]
        if (previous_state._about_to_exit):
            if (_debug_mode):
                print("@FSM calling about_to_exit -> ", previous_state)
            previous_state._about_to_exit.call()

    _previous_state = _current_state
    _current_state = state_enum_value
    var state: State = _states[_current_state]

    if (state._about_to_enter):
        if (_debug_mode):
            print("@FSM calling about_to_enter -> ", state)
        state._about_to_enter.call()

    if (state._in_state):
        if (_debug_mode):
            print("@FSM calling in_state -> ", state)
        state._in_state.call()

func get_state() -> int:
    return _current_state

func get_previous_state() -> int:
    return _previous_state
