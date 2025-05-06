@icon("res://assets/icons/trait.png")
class_name TraitInterface
extends Node2D

func set_spawn_info(_spawn_info: SpawnInfo, _friendly: bool) -> void:
    pass

func increment_position(position_increment: Vector2) -> void:
    global_position += position_increment

func connect_on_body_hurted(_callable: Callable) -> void:
    pass

func get_hurtbox() -> HurtBoxComponent:
    return null

func set_direction(_direction: Vector2) -> void:
    pass

func get_direction() -> Vector2:
    return Vector2.ZERO
