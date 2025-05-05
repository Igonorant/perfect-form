class_name Player
extends CharacterBody2D

@onready var _velocity: VelocityComponent = $VelocityComponent
@onready var _health: HealthComponent = $HealthComponent
@onready var _invulnerability_timer: Timer = $InvulnerabilityTimer
@onready var _blinking_animation: BlinkingComponent = $BlinkingComponent
@onready var _sprite: Sprite2D = $Sprite2D

@onready var scn_projectile: PackedScene = preload("res://test_stuff/projectile_zap.tscn")
@onready var scn_shockwave: PackedScene = preload("res://test_stuff/shockwave.tscn")
@onready var scn_projectile_burst: PackedScene = preload("res://test_stuff/projectile_burst.tscn")


var _player_input_direction: Vector2 # Player inputs direction
var _player_last_input_direction: Vector2 # Player last inputs direction


func _ready() -> void:
    _player_input_direction = Vector2.ZERO
    _player_last_input_direction = Vector2.ZERO

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
    if Input.is_action_just_pressed("atk_q"):
        _spawn_projectile(1)
    if Input.is_action_just_pressed("atk_e"):
        _spawn_shockwave()
    if Input.is_action_just_pressed("atk_w"):
        _spawn_projectile_burst(5)
    if Input.is_action_just_pressed("atk_r"):
        _spawn_projectile(10)


func _spawn_projectile_burst(amount: int) -> void:
    for i in range(amount):
        var projectile_instance: ProjectileBurst = scn_projectile_burst.instantiate()
        projectile_instance.global_position = global_position
        var direction = _player_last_input_direction if _player_input_direction.is_zero_approx() else _player_input_direction
        owner.add_child(projectile_instance)
        projectile_instance.set_direction(direction.rotated(randf_range(-PI / 6, PI / 6)))

func _spawn_projectile(amount: int) -> void:
    for i in range(amount):
        var projectile_instance: Projectile = scn_projectile.instantiate()
        projectile_instance.global_position = global_position
        var direction = _player_last_input_direction if _player_input_direction.is_zero_approx() else _player_input_direction
        owner.add_child(projectile_instance)
        projectile_instance.set_direction(direction.rotated(randf_range(-PI / 6, PI / 6)))

func _spawn_shockwave() -> void:
    var shockwave_instance: Shockwave = scn_shockwave.instantiate()
    shockwave_instance.m_spawn_position = position
    shockwave_instance.m_spawn_rotation = randf_range(0.0, TAU)
    shockwave_instance.set_spawner(self)
    owner.add_child(shockwave_instance)

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

func take_damage(amount: float) -> void:
    if (_invulnerability_timer.is_stopped()):
        _health.deal_damage(amount)
        _invulnerability_timer.start()
        _blinking_animation.start_blinking(_invulnerability_timer.wait_time)
