class_name PorcupineEnemy
extends CharacterBody2D

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _health: HealthComponent = %HealthComponent
@onready var _animation: AnimationPlayer = %AnimationPlayer
@onready var _hit_box: CollisionShape2D = %HitBox

@onready var _idle_timer: Timer = %IdleTimer
@onready var _moving_timer: Timer = %MovingTimer
@onready var _dead_timer: Timer = %DeadTimer

var _target: Node2D
var _invulnerable: bool = false

enum State {IDLE, MOVING, ATTACKING, TAKING_DAMAGE, DEAD}
const _StateStrings := ["IDLE", "MOVING", "ATTACKING", "TAKING_DAMAGE", "DEAD"]
var _current_state: State = State.IDLE
var _last_state: State = State.IDLE

func _ready() -> void:
    _idle_timer.timeout.connect(_on_idle_timer_timeout)
    _moving_timer.timeout.connect(_on_moving_timer_timeout)
    _dead_timer.timeout.connect(_on_dead_timer_timeout)

    _animation.animation_finished.connect(_on_animation_finished)

    _animation.play("idle")
    _idle_timer.start()
    _invulnerable = true

func set_target(target: Node2D) -> void:
    _target = target

func _physics_process(_delta: float) -> void:
    match _current_state:
        State.IDLE:
            _handle_idle_state()
        State.MOVING:
            _handle_moving_state()
        State.ATTACKING:
            _handle_attacking_state()
        State.TAKING_DAMAGE: pass
        State.DEAD: return
    move_and_slide()

func take_damage(damages: Array[Damage]) -> void:
    if (_invulnerable):
        return
    for damage in damages:
        _health.deal_damage(damage.amount)
        if (_health.is_depleted()):
            _handle_entering_dead_state()
            return
    _set_state(State.TAKING_DAMAGE)
    _animation.play("taking_damage")

func _handle_idle_state() -> void:
    _animation.play("idle")
    velocity = velocity.lerp(Vector2.ZERO, 0.2);

func _handle_moving_state() -> void:
    _velocity.set_acceleration_direction(_target.global_position - global_position)
    velocity = _velocity.get_velocity()

func _handle_attacking_state() -> void:
    velocity = velocity.lerp(Vector2.ZERO, 0.2);

func _attack() -> void:
    pass

func _on_idle_timer_timeout() -> void:
    _set_state(State.MOVING)
    _invulnerable = false
    _animation.play("moving")
    _moving_timer.start()

func _on_moving_timer_timeout() -> void:
    _set_state(State.ATTACKING)
    _animation.play("attacking")
    _attack()

func _on_dead_timer_timeout() -> void:
    queue_free()

func _handle_entering_dead_state() -> void:
    _animation.play("taking_damage_fatal")
    _velocity.queue_free()
    _health.queue_free()
    _hit_box.queue_free()
    _dead_timer.start()
    _set_state(State.DEAD)

func _on_animation_finished(anim_name: StringName) -> void:
    print("_on_animation_finished -> ", anim_name)
    match anim_name:
        "attacking":
            _set_state(State.IDLE)
        "taking_damage":
            _set_state(_last_state)

func _set_state(state: State) -> void:
    print(Time.get_ticks_msec() / 1000.0, " - (last) ", _StateStrings[_last_state], " <- (current) ", _StateStrings[_current_state], "  <- (change to) ", _StateStrings[state], ")")
    if (_current_state != State.DEAD):
        _last_state = _current_state
        _current_state = state
        match _current_state:
            State.IDLE:
                _idle_timer.start()
            State.MOVING:
                _moving_timer.start()
    print("      - ", _StateStrings[_current_state], " (was ", _StateStrings[_last_state], ")")
