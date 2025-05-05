@icon("res://assets/placeholder_lightning_effect.png")
class_name Shockwave
extends Node2D

var m_spawn_position: Vector2
var m_spawn_rotation: float
var m_spawner: Node2D

func _ready() -> void:
    position = m_spawn_position
    rotation = m_spawn_rotation


func _physics_process(_delta: float) -> void:
    position = m_spawner.position

func set_spawner(spawner: Node2D) -> void:
    m_spawner = spawner

func _on_life_timeout() -> void:
    queue_free()
