@icon("res://assets/icons/hud.png")
class_name PlayerHUD
extends Control

@onready var health_bar = %HealthBar

func _ready() -> void:
    health_bar.value = health_bar.max_value

func connect_to_player(player: Player) -> void:
    player._connect_to_hud(_update_health_bar)

func _update_health_bar(health_percentage: float) -> void:
    health_bar.value = health_percentage * 100.0
