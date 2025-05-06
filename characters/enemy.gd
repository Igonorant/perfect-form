class_name Enemy
extends CharacterBody2D

@onready var _velocity: VelocityComponent = %VelocityComponent
@onready var _health: HealthComponent = %HealthComponent

var _target: Node2D

func _ready() -> void:
    pass

func _physics_process(_delta: float) -> void:
    _velocity.set_acceleration_direction(_target.global_position - global_position)
    velocity = _velocity.get_velocity()
    move_and_slide()

func set_target(target: Node2D) -> void:
    _target = target

func take_damage(damages: Array[Damage]) -> void:
    for damage in damages:
        _health.deal_damage(damage.amount)
        if (_health.is_depleted()):
            queue_free()
