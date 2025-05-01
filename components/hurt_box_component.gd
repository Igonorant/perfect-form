class_name HurtBoxComponent
extends Area2D

signal hurt_body(body: Node2D)

func _on_body_entered(body: Node2D) -> void:
    hurt_body.emit(body)
