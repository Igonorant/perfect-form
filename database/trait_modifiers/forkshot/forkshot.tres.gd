class_name ForkshotRes
extends TraitModifier

var _power: Power

# TODO: maybe replace by a set_power function with overwritting init with parameter becomes a problem
func _init(power: Power) -> void:
    _power = power

func on_hurt_inject(hurter: TraitInterface, hurted: Node2D) -> void:
    if (hurter.is_forked()):
        return

    var hitbox: CollisionShape2D = hurted.find_child("HitBox", false)
    if hitbox == null:
        return

    # TODO: maybe add some damage scaling as well
    var new_instances_scale = 0.67

    # Calculate minimum distance to spawn new instances outside the hurted hitbox.
    # Add a 35% safe margin to the minimum distance
    var min_distance = sqrt(
        hurter.get_hurtbox().get_shape_rect().size.length_squared() +
        (hitbox.shape.get_rect().size * new_instances_scale).length_squared() / 4
    ) * 1.35

    # Helper function to create and position a new hurter instance
    var create_hurter = func(rotation_angle: float) -> void:
        var new_direction = hurter.get_direction().rotated(rotation_angle)
        var spawn_info: SpawnInfo = SpawnInfo.new()
        spawn_info.spawn_position = hurter.global_position + new_direction * min_distance
        spawn_info.spawn_direction = hurter.get_direction().rotated(rotation_angle)
        spawn_info.is_forked = true
        _power.spawn(spawn_info)

    var forked_rotation: float = PI / 4
    create_hurter.call(forked_rotation)
    create_hurter.call(-forked_rotation)

    if (!hurter.has_pierce_modifier()):
        hurter.queue_free()
