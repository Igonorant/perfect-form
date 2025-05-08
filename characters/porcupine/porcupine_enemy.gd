class_name PorcupineEnemy
extends CharacterBody2D

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _animation: AnimationPlayer = %AnimationPlayer
@onready var _hit_box: CollisionShape2D = %HitBox

@onready var _idle_timer: Timer = %IdleTimer
@onready var _moving_timer: Timer = %MovingTimer
@onready var _dead_timer: Timer = %DeadTimer

@onready var _main_sprite: Sprite2D = %MainSprite2D
@onready var _spikes_sprite: Sprite2D = %SpikesSprite2D
@onready var _hurtbox_collision_shape: CollisionShape2D = %CollisionShape2D


var _main_sprite_original_position: Vector2
var _spikes_sprite_original_position: Vector2
var _hurtbox_collision_shape_original_position: Vector2

var _target: Node2D
var _invulnerable: bool = false

var _power: Power
enum ModifierOption {NONE, MULTISHOT}
@onready var _trait_scene: PackedScene = preload("uid://b80u6558u77jj")

enum Behavior {IDLE, MOVING, ATTACKING, TAKING_DAMAGE, DEAD}
@onready var _fsm: StateMachine = StateMachine.new()

func _ready() -> void:
    _idle_timer.timeout.connect(_on_idle_timer_timeout)
    _moving_timer.timeout.connect(_on_moving_timer_timeout)
    _dead_timer.timeout.connect(_on_dead_timer_timeout)

    _animation.animation_finished.connect(_on_animation_finished)

    _main_sprite_original_position = _main_sprite.position
    _spikes_sprite_original_position = _spikes_sprite.position
    _hurtbox_collision_shape_original_position = _hurtbox_collision_shape.position

    _fsm.add_state(State.new(Behavior.IDLE, "IDLE", _about_to_enter_idle, _in_state_idle, Callable()))
    _fsm.add_state(State.new(Behavior.MOVING, "MOVING", _about_to_enter_moving, Callable(), Callable()))
    _fsm.add_state(State.new(Behavior.ATTACKING, "ATTACKING", _about_to_enter_attacking, _in_state_attacking, Callable()))
    _fsm.add_state(State.new(Behavior.TAKING_DAMAGE, "TAKING_DAMAGE", _about_to_enter_taking_damage, Callable(), _about_to_exit_taking_damage))
    _fsm.add_state(State.new(Behavior.DEAD, "DEAD", _about_to_enter_dead, in_state_dead, Callable()))
    _fsm.end_adding_states()
    _fsm.set_state(Behavior.IDLE)

    _create_power()

    _invulnerable = true

func _create_power() -> void:
    _power = Power.new()
    _power.set_unfriendly()
    _power.set_trait(_trait_scene)
    var trait_to_add: ModifierOption = ModifierOption.values().pick_random()
    match trait_to_add:
        ModifierOption.NONE: pass
        ModifierOption.MULTISHOT: _power.add_trait_modifier(MultishotRes.new())
    add_child(_power)

func set_target(target: Node2D) -> void:
    _target = target

func _physics_process(_delta: float) -> void:
    match _fsm.get_state():
        Behavior.IDLE: pass
        Behavior.MOVING:
            _in_state_moving_physics_process()
        Behavior.ATTACKING: pass
        Behavior.TAKING_DAMAGE: pass
        Behavior.DEAD: pass

    velocity = _velocity.get_velocity()
    if (velocity.x >= 1):
        turn_right()
    elif (velocity.x <= -1):
        turn_left()

    move_and_slide()

func turn_left() -> void:
    var neg_x := Vector2(-1, 1)
    _main_sprite.flip_h = true
    _main_sprite.position = _main_sprite_original_position * neg_x
    _spikes_sprite.flip_h = true
    _spikes_sprite.position = _spikes_sprite_original_position * neg_x
    _hurtbox_collision_shape.position = _hurtbox_collision_shape_original_position * neg_x

func turn_right() -> void:
    _main_sprite.flip_h = false
    _main_sprite.position = _main_sprite_original_position
    _spikes_sprite.flip_h = false
    _spikes_sprite.position = _spikes_sprite_original_position
    _hurtbox_collision_shape.position = _hurtbox_collision_shape_original_position


### IDLE STATE ###
#region idle_state

func _about_to_enter_idle() -> void:
    _animation.play("idle")
    _idle_timer.start()

func _in_state_idle() -> void:
    _velocity.set_acceleration_direction(Vector2.ZERO)

func _on_idle_timer_timeout() -> void:
    _invulnerable = false
    _fsm.set_state(Behavior.MOVING)

#endregion

### MOVING STATE ###
#region moving_state

func _about_to_enter_moving() -> void:
    _animation.play("moving")
    _moving_timer.start()

func _on_moving_timer_timeout() -> void:
    _fsm.set_state(Behavior.ATTACKING)

func _in_state_moving_physics_process() -> void:
    _velocity.set_acceleration_direction(_target.global_position - global_position)

#endregion

### ATTACKING STATE ###
#region attacking_state

func _about_to_enter_attacking() -> void:
    _animation.play("attacking")

func _in_state_attacking() -> void:
    _velocity.set_acceleration_direction(Vector2.ZERO)
    _attack()

func _attack() -> void:
    var spawn_info := SpawnInfo.new()
    spawn_info.spawn_position = global_position
    spawn_info.spawn_direction = (_target.global_position - global_position).normalized()
    _power.spawn(spawn_info)

func _on_animation_finished(anim_name: StringName) -> void:
    match anim_name:
        "attacking":
            _fsm.set_state(Behavior.IDLE)
        "taking_damage":
            _fsm.set_state(_fsm.get_previous_state())

#endregion

### TAKING DAMAGE STATE ###
#region taking_damage_state

func _about_to_enter_taking_damage() -> void:
    _animation.play("taking_damage")

    _velocity.set_acceleration_direction(Vector2.ZERO)

    _idle_timer.paused = true
    _moving_timer.paused = true

func _about_to_exit_taking_damage() -> void:
    _idle_timer.paused = false
    _moving_timer.paused = false

func take_damage(damages: Array[Damage]) -> void:
    if (_invulnerable):
        return

    var took_damage: bool = false
    for damage in damages:
        if (!_health.is_depleted()):
            _health.deal_damage(damage.amount)
            took_damage = true

    if (_health.is_depleted()):
        _fsm.set_state(Behavior.DEAD)
        _fsm.lock()
        return

    if (took_damage):
        _fsm.set_state(Behavior.TAKING_DAMAGE)

#endregion

### DEAD STATE ###
#region dead_state

func _on_dead_timer_timeout() -> void:
    queue_free()

func _about_to_enter_dead() -> void:
    _animation.play("RESET")
    _animation.play("taking_damage_fatal")

func in_state_dead() -> void:
    _velocity.set_acceleration_direction(Vector2.ZERO)

    _health.queue_free()
    _hit_box.queue_free()

    _idle_timer.stop()
    _moving_timer.stop()
    _dead_timer.start()

#endregion