@icon("uid://dpc6ftmmk58xb")
class_name TraitModifier
extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D

## Injects its modifications in the power, like amount of traits to spawn, changes in trait spawn position ...
func spawn_power_inject(_power: Power, _spawn_info: SpawnInfo) -> void:
    pass

## Injects its modifications in the trait instance, before calling _ready function, like more damage, increased effect ...
func spawn_trait_inject_before_ready(_trait_instance: TraitInterface) -> void:
    pass

## Injects its modifications in the trait instance, after calling _ready function, like more damage, increased effect ...
func spawn_trait_inject_after_ready(_trait_instance: TraitInterface, _spawn_info: SpawnInfo) -> void:
    pass

## Injects its modifications in the physics process, like direction control of projectiles ...
func physics_process_inject(_trait_instance: TraitInterface, _delta: float) -> void:
    pass

## Injects its modifications when something is hurt, like forking a projectile, shatter ...
func on_hurt_inject(_hurter: TraitInterface, _hurted: Node2D) -> void:
    pass
