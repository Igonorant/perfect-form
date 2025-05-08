@icon("res://assets/icons/hud.png")
class_name PlayerHUD
extends Control

@export var player: Player

@onready var health_bar = %HealthBar

var player_health_component: HealthComponent

func _ready() -> void:
    health_bar.value = health_bar.max_value

func connect_to_player() -> void:
    player._connect_to_hud(_update_health_bar)

func _update_health_bar(health_percentage: float) -> void:
    health_bar.value = health_percentage * 100.0

func _process(_delta: float) -> void:
    var parent: Camera2D = get_parent()
    global_position = parent.get_screen_center_position() + Vector2(-320, -180)
