class_name TraitModifier
extends Resource

## Injects its modifications in the power, like amount of traits to spawn, changes in trait spawn position ...
func spawn_power_inject(_power: Power) -> void:
    pass

## Injects its modifications in the trait instance, before calling _ready function, like more damage, increased effect ...
func spawn_trait_inject_before_ready(_trait_instance: TraitInterface) -> void:
    pass

## Injects its modifications in the trait instance, after calling _ready function, like more damage, increased effect ...
func spawn_trait_inject_after_ready(_trait_instance: TraitInterface) -> void:
    pass

## Injects its modifications in the physics process, like direction control of projectiles ...
## TODO: is called during spawn right after spawn_trait_inject_after_ready, I still need to think if it is the best place to call it
func physics_process_inject(_trait_instance: TraitInterface) -> void:
    pass

## Injects its modifications when something is hurt, like forking a projectile, shatter ...
## TODO: is called during spawn right after spawn_trait_inject_after_ready, I still need to think if it is the best place to call it
func on_hurt_inject(_trait_instance: TraitInterface) -> void:
    pass
