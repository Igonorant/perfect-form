@icon("res://assets/icons/external/pixel-boy/node_2D/icon_area_damage.png")
class_name HitBox
extends Area2D

@export var on_hit_effect: Effect

func _to_string() -> String:
    return on_hit_effect._to_string()

func get_on_hit_effects() -> Array[EffectRes]:
    return on_hit_effect.get_effects()
