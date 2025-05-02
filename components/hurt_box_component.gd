class_name HurtBoxComponent
extends Area2D

@export var damage: float = 0.0

signal hurt_body(body: Node2D, damage: float)

func _on_body_entered(body: Node2D) -> void:
    hurt_body.emit(body, damage)

func connect_damage_handler(handler) -> void:
    hurt_body.connect(handler)
