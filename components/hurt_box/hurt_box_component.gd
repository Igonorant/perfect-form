class_name HurtBoxComponent
extends Area2D

@export var damages: Array[Damage] = []

signal body_hurted(body: Node2D)

func _on_body_entered(body: Node2D) -> void:
    # print("@Hurtbox of : ", get_parent().name, " - Body entered: ", body.name)
    if body.has_method("take_damage"):
        body.take_damage(damages)
        emit_signal("body_hurted", body)
