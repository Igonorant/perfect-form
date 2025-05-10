class_name HurtBoxComponent
extends Area2D

@export var damages: Array[TraitInfo] = []

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

signal body_hurted(hurter: Node2D, hurted: Node2D)

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("take_damage"):
        body.take_damage(damages)
        emit_signal("body_hurted", get_parent(), body)

func get_shape_rect() -> Rect2:
    return collision_shape.shape.get_rect()

func add_damages(damages_to_add: Array[TraitInfo]) -> void:
    damages.append_array(damages_to_add)
