class_name Multishot
extends TraitModifier

var _total_number_of_projectiles: int = 2
func spawn_power_inject(power: Power) -> void:
    power._trait_spawn_amount = _total_number_of_projectiles

var _direction_rotation_limit: float = PI / 18
var _instances_counter: int = 0
func spawn_trait_inject_before_ready(trait_instance: TraitInterface) -> void:
    # Prevents some interaction when a instance is forked, preventing it to fork into multiple new instances
    _instances_counter = (_instances_counter + 1) % _total_number_of_projectiles
    if (trait_instance.is_forked() and _instances_counter > 0):
        trait_instance.queue_free()
        return

    # Rotate direction a little bit to give some spread to the instance
    var new_direction = trait_instance.get_direction().rotated(
        randf_range(-_direction_rotation_limit, _direction_rotation_limit))
    trait_instance.set_direction(new_direction)
