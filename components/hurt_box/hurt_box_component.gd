class_name HurtBoxComponent
extends Area2D

@export var damage: float = 0.0

signal body_hurted(body: Node2D)

func _on_body_entered(body: Node2D) -> void:
    # print("@Hurtbox of : ", get_parent().name, " - Body entered: ", body.name)
    if body.has_method("take_damage"):
        body.take_damage(damage)
        emit_signal("body_hurted", body)
