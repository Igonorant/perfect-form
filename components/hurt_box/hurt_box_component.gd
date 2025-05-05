class_name HurtBoxComponent
extends Area2D

@export var damage: float = 0.0

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("take_damage"):
        body.take_damage(damage)
