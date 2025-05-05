class_name Player
extends CharacterBody2D

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _invulnerability: InvulnerabilityComponent = %InvulnerabilityComponent
@onready var _sprite: Sprite2D = $Sprite2D

# @onready var scn_projectile: PackedScene = preload("res://test_stuff/projectile_zap.tscn")
# @onready var scn_shockwave: PackedScene = preload("res://test_stuff/shockwave.tscn")
# @onready var scn_projectile_burst: PackedScene = preload("res://test_stuff/projectile_burst.tscn")

@export var q_press_trait: PackedScene = null
@export var w_press_trait: PackedScene = null
@export var e_press_trait: PackedScene = null


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
    if Input.is_action_just_pressed("atk_q") and q_press_trait != null:
        _spawn_active_trait(q_press_trait)
    if Input.is_action_just_pressed("atk_e") and e_press_trait != null:
        _spawn_active_trait(e_press_trait)
    if Input.is_action_just_pressed("atk_w") and w_press_trait != null:
        _spawn_active_trait(w_press_trait)


func _spawn_active_trait(active_trait: PackedScene) -> void:
    # Create a new instance of the active trait
    var instance: ActiveTrait = active_trait.instantiate()

    # Set the global starting position of the active trait
    instance.global_position = global_position

    # Set the direction of the active trait
    var direction = _player_last_input_direction if _player_input_direction.is_zero_approx() else _player_input_direction
    instance.set_direction(direction)

    # Add to tree
    owner.add_child(instance)


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
    if (_invulnerability.is_active()):
        return
    _health.deal_damage(amount)
    _invulnerability.activate()
