class_name RingshotRes
extends TraitModifier

# TODO: consider unifying this class with multishot and shotgunizer, since they are almost the same

const _total_number_of_projectiles: int = 20
func spawn_power_inject(power: Power, _spawn_info: SpawnInfo) -> void:
    power._trait_spawn_amount = _total_number_of_projectiles

const _projectile_rotation: float = TAU / _total_number_of_projectiles
var _instances_counter: int = 0
func spawn_trait_inject_before_ready(trait_instance: TraitInterface) -> void:
    # Prevents some interaction when a instance is forked, preventing it to fork into multiple new instances
    _instances_counter = (_instances_counter + 1) % _total_number_of_projectiles
    if (trait_instance.is_forked() and _instances_counter > 0):
        trait_instance.queue_free()
        return

    # Rotate direction a little bit to give some spread to the instance
    var new_direction = trait_instance.get_direction().rotated(_projectile_rotation * _instances_counter)
    trait_instance.set_direction(new_direction)

const _life_timer_wait_time = 0.35 # Consider using trait speed to calculate this
func spawn_trait_inject_after_ready(_trait_instance: TraitInterface, _spawn_info: SpawnInfo) -> void:
    var life_timer: Timer = _trait_instance.find_child("LifeTimer")
    if (life_timer):
        life_timer.wait_time = _life_timer_wait_time
        life_timer.start()
