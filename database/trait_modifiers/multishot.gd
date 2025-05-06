class_name Multishot
extends TraitModifier

var _total_number_of_projectiles: int = 3
func spawn_power_inject(power: Power) -> void:
    power._trait_spawn_amount = _total_number_of_projectiles

var _direction_rotation_limit: float = PI / 18
func spawn_trait_inject_before_ready(trait_instance: TraitInterface) -> void:
    var new_direction = trait_instance.get_direction().rotated(
        randf_range(-_direction_rotation_limit, _direction_rotation_limit))
    trait_instance.set_direction(new_direction)
