@icon("res://assets/icons/health.png")
class_name HealthComponent
extends Node

@export var max_health: float = 100.0
@export var add_health_bar: bool = true

@onready var _current_health: float = max_health
@onready var _health_bar: ProgressBar = %HealthBar
@onready var _parent: Node = get_parent()

signal health_depleted
signal health_changed(health_percentage: float)

func _ready() -> void:
    if add_health_bar:
        _configure_health_bar()
    else:
        _health_bar.queue_free()

func _configure_health_bar() -> void:
    _health_bar.min_value = 0.0
    _health_bar.max_value = max_health
    _health_bar.value = _current_health

    _health_bar.set_size(Vector2(48, 8))
    _health_bar.set_position(_get_health_bar_position())

func _physics_process(_delta: float) -> void:
    if _health_bar:
        _health_bar.set_position(_get_health_bar_position())

func _get_health_bar_position() -> Vector2:
    return _parent.get_global_position() + Vector2(-24, -36)

func deal_damage(damage: float) -> void:
    _current_health -= damage
    if (_health_bar): _health_bar.value = _current_health
    health_changed.emit(get_percentage_health())
    if (_current_health <= 0.0):
        _current_health = 0.0
        if (_health_bar): _health_bar.queue_free()
        health_depleted.emit()

func heal(amount: float) -> void:
    if (_current_health < max_health):
        _current_health = min(max_health, _current_health + amount)
        if (_health_bar): _health_bar.value = _current_health
        health_changed.emit(get_percentage_health())

func get_percentage_health() -> float:
    return _current_health / max_health

func is_depleted() -> bool:
    return _current_health <= 0.0
