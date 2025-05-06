@icon("res://assets/icons/trait.png")
class_name TraitInterface
extends Node2D

func set_spawn_info(_spawn_info: SpawnInfo, _friendly: bool) -> void:
    pass

func increment_direction(_direction_increment: Vector2) -> void:
    pass

func connect_on_body_hurted(_callable: Callable) -> void:
    pass