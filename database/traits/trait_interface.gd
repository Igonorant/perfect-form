@icon("res://assets/icons/trait.png")
class_name TraitInterface
extends Node2D

@onready var _out_of_game_bounds = get_viewport_rect().grow(360.0)

func _free_if_out_of_game_bounds() -> void:
    if (!_out_of_game_bounds.has_point(global_position)):
        queue_free()

var _original_scale: Vector2 = Vector2.ONE
var _original_scale_increment: Vector2 = Vector2.ONE
func _ready() -> void:
    _original_scale = scale
    scale = Vector2(0.05, 0.05)
    _original_scale_increment = (_original_scale - scale) / 10

func _scale_back_to_original() -> void:
    if (_original_scale != scale):
        scale += _original_scale_increment
        if (scale > _original_scale):
            scale = _original_scale

func _physics_process(_delta: float) -> void:
    _scale_back_to_original()
    _free_if_out_of_game_bounds()

func _get_collision_layer(friendly: bool) -> int:
    # Friendly effect or Unfriendly effect layer
    return 0b01000 if friendly else 0b10000

func _get_collision_mask(friendly: bool) -> int:
    # Environment and Player or Enemy collision mask
    return 0b101 if friendly else 0b011

func set_collision_layer_and_mask(friendly: bool) -> void:
    var hurt_box := get_hurtbox()
    hurt_box.collision_layer = _get_collision_layer(friendly)
    hurt_box.collision_mask = _get_collision_mask(friendly)


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

func add_damages(damages_to_add: Array[TraitEffect]) -> void:
    get_hurtbox().add_damages(damages_to_add)
