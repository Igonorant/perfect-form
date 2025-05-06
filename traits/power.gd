class_name Power
extends Node

@export var trait_interface: PackedScene = null
@export var trait_modifiers: Array[TraitModifier] = []
@export var friendly: bool = true

var _trait_spawn_amount: int = 1


func spawn(spawn_info: SpawnInfo) -> void:
    # Inject modification in the power
    for trait_modifier in trait_modifiers:
        trait_modifier.spawn_power_inject(self)

    for idx in range(_trait_spawn_amount):
        # Create a new instance of the trait
        var instance: TraitInterface = trait_interface.instantiate()
        instance.set_spawn_info(spawn_info, friendly)

        # Inject modification in each instance before ready
        for trait_modifier in trait_modifiers:
            trait_modifier.spawn_trait_inject_before_ready(instance)

        add_child(instance)

    for instance in get_children():
        # Inject modification in each instance after ready
        for trait_modifier in trait_modifiers:
            trait_modifier.spawn_trait_inject_after_ready(instance)
            trait_modifier.physics_process_inject(instance)
            trait_modifier.on_hurt_inject(instance)
