@icon("res://assets/icons/external/pixel-boy/node_2D/icon_hitbox.png")
class_name HurtBox
extends Area2D

func _ready() -> void:
    area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: HitBox) -> void:
    #print("Hitbox entered: ", hitbox)
    print(hitbox.get_on_hit_effects())