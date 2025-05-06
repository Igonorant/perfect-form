class_name Multishot
extends TraitModifier

var _total_number_of_projectiles: int = 3
func spawn_power_inject(power: Power) -> void:
    power._trait_spawn_amount = _total_number_of_projectiles

var _direction_increment_limit: float = 0.1
func spawn_trait_inject_before_ready(trait_instance: TraitInterface) -> void:
    trait_instance.increment_direction(Vector2(
        randf_range(-_direction_increment_limit, _direction_increment_limit),
        randf_range(-_direction_increment_limit, _direction_increment_limit)
    ))
