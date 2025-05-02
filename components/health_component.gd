@icon("res://assets/icons/health.png")
class_name HealthComponent
extends Node

@export var max_health : float = 100.0

var m_current_health : float

signal health_depleted
signal health_changed

func _ready() -> void:
    m_current_health = max_health
    
func deal_damage(damage: float) -> void:
    m_current_health -= damage
    health_changed.emit()
    if (m_current_health <= 0.0):
        m_current_health = 0.0
        health_depleted.emit()

func heal(amount: float) -> void:
    if (m_current_health < max_health):
        m_current_health = min(max_health, m_current_health + amount)
        health_changed.emit()
        
func get_percentage_health() -> float:
    return m_current_health / max_health
    
