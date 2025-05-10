class_name StaticEnemy
extends CharacterBody2D

@onready var _health: HealthComponent = %HealthComponent

var _target: Node2D

func _ready() -> void:
    pass

func _physics_process(_delta: float) -> void:
    move_and_slide()

func set_target(target: Node2D) -> void:
    _target = target

func take_damage(damages: Array[TraitEffect]) -> void:
    for damage in damages:
        _health.deal_damage(damage.effect_amount)
        if (_health.is_depleted()):
            queue_free()
