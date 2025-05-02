@icon("res://assets/icons/hud.png")
class_name PlayerHUD
extends Node

@export var player: Player

@onready var health_bar = $TopLeftHUD/HealthBar
@onready var player_health_component = player.c_health

func _ready() -> void:
    health_bar.value = health_bar.max_value
    assert(health_bar.max_value == 100.0, "Health bar max value means 100%")
    player_health_component.health_changed.connect(_update_health_bar)


func _update_health_bar() -> void:
    health_bar.value = player_health_component.get_percentage_health() * 100.0
