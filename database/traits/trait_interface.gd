@icon("res://assets/icons/trait.png")
class_name TraitInterface
extends Node2D

@onready var _friendly_effect_collision_layer: int = 0b01000 # Friendly effect layer
@onready var _friendly_effect_collision_mask: int = 0b101 # Environment and Enemies layer
@onready var _unfriendly_effect_collision_layer: int = 0b10000 # Unfriendly effect layer
@onready var _unfriendly_effect_collision_mask: int = 0b011 # Environment and Player layer

@onready var _out_of_game_bounds = get_viewport_rect().grow(360.0)

func _free_if_out_of_game_bounds() -> void:
    if (!_out_of_game_bounds.has_point(global_position)):
        queue_free()

func _physics_process(_delta: float) -> void:
    _free_if_out_of_game_bounds()

func set_spawn_info(_spawn_info: SpawnInfo) -> void:
    pass

func increment_position(position_increment: Vector2) -> void:
    global_position += position_increment

func connect_on_body_hurted(_callable: Callable) -> void:
    pass

func is_forked() -> bool:
    return false

func has_pierce_modifier() -> bool:
    return false

func get_hurtbox() -> HurtBoxComponent:
    return null

func set_direction(_direction: Vector2) -> void:
    pass

func get_direction() -> Vector2:
    return Vector2.ZERO

func add_damages(damages_to_add: Array[Damage]) -> void:
    get_hurtbox().add_damages(damages_to_add)

func set_collision_layer_and_mask(friendly: bool) -> void:
    var hurt_box := get_hurtbox()
    if (friendly):
        hurt_box.collision_layer = _friendly_effect_collision_layer
        hurt_box.collision_mask = _friendly_effect_collision_mask
    else:
        hurt_box.collision_layer = _unfriendly_effect_collision_layer
        hurt_box.collision_mask = _unfriendly_effect_collision_mask