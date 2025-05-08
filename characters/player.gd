class_name Player
extends CharacterBody2D

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _invulnerability: InvulnerabilityComponent = %InvulnerabilityComponent
@onready var _sprite: Sprite2D = $Sprite2D

var q_press_power: Power = null
var w_press_power: Power = null
var e_press_power: Power = null


var _player_input_direction: Vector2 # Player inputs direction
var _player_last_input_direction: Vector2 # Player last inputs direction


func _ready() -> void:
    _player_input_direction = Vector2.ZERO
    _player_last_input_direction = Vector2.ZERO

    # THIS IS TEMPORARY TEST CODE
    q_press_power = Power.new()
    q_press_power.trait_interface = load("res://traits/active_traits/porcupine_quill/porcupine_quill.tscn")
    q_press_power.trait_modifiers = [ForkshotRes.new(q_press_power), MultishotRes.new(), PierceshotRes.new(), ExplodeOnImpactRes.new(q_press_power)]
    q_press_power.friendly = true
    owner.call_deferred("add_child", q_press_power)

func _connect_to_hud(update_health_bar: Callable) -> void:
    _health.health_changed.connect(update_health_bar)

func _physics_process(_delta: float) -> void:
    _calculate_direction()
    _handle_inputs()
    _move()
    _update_sprite_direction()

func _calculate_direction() -> void:
    _player_input_direction = Vector2.ZERO
    _player_input_direction.x = Input.get_axis("move_left", "move_right");
    _player_input_direction.y = Input.get_axis("move_up", "move_down");
    if (!_player_input_direction.is_zero_approx()):
        _player_last_input_direction = _player_input_direction

func _handle_inputs() -> void:
    if Input.is_action_just_pressed("atk_q") and q_press_power != null:
        _spawn_power(q_press_power)
    if Input.is_action_just_pressed("atk_w") and w_press_power != null:
        _spawn_power(w_press_power)
    if Input.is_action_just_pressed("atk_e") and e_press_power != null:
        _spawn_power(e_press_power)

func _spawn_power(power: Power) -> void:
    var spawn_info: SpawnInfo = SpawnInfo.new()
    spawn_info.spawn_position = global_position
    spawn_info.spawn_direction = _player_last_input_direction if _player_input_direction.is_zero_approx() else _player_input_direction
    power.spawn(spawn_info)


func _move() -> void:
    _velocity.set_acceleration_direction(_player_input_direction)
    velocity = _velocity.get_velocity()
    move_and_slide()

func _update_sprite_direction() -> void:
    # This needs to be a little bit complex to avoid flipping the sprite when input direction is 0.
    if (_sprite.flip_h):
        if (_player_input_direction.x < 0.0):
            _sprite.flip_h = false
    elif (_player_input_direction.x > 0.0):
        _sprite.flip_h = true

func take_damage(damages: Array[Damage]) -> void:
    if (_invulnerability.is_active()):
        return
    for damage in damages:
        _health.deal_damage(damage.amount)
    _invulnerability.activate()
