class_name Power
extends Node

@export var trait_interface: PackedScene = null
@export var trait_modifiers: Array[TraitModifier] = []
@export var friendly: bool = true

var _trait_spawn_amount: int

func _reset() -> void:
    _trait_spawn_amount = 1

func spawn(spawn_info: SpawnInfo) -> void:
    # Reset status of the power to the default
    _reset()

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

        call_deferred("add_child", instance)
        # _finish_spawn should be called after add child to ensure _ready function has already happened
        call_deferred("_finish_spawn", instance)

# This should be called after add child to ensure _ready function already have happened
func _finish_spawn(instance):
    # Inject modification in each instance after ready
    for trait_modifier in trait_modifiers:
        trait_modifier.spawn_trait_inject_after_ready(instance)

    # Add callback to _on_body_hurted
    instance.connect_on_body_hurted(_on_body_hurted)

func _physics_process(delta: float) -> void:
    for instance in get_children():
        if (instance is TraitInterface):
            # Inject modification in each instance after ready
            for trait_modifier in trait_modifiers:
                trait_modifier.physics_process_inject(instance, delta)

func _on_body_hurted(hurter: Node2D, hurted: Node2D) -> void:
    for trait_modifier in trait_modifiers:
            trait_modifier.on_hurt_inject(hurter, hurted)
