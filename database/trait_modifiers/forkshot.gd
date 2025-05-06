class_name Forkshot
extends TraitModifier

func on_hurt_inject(hurter: TraitInterface, hurted: Node2D) -> void:
    var hitbox: CollisionShape2D = hurted.find_child("HitBox", false)
    if hitbox == null:
        return

    # TODO: maybe add some damage scaling as well
    var new_instances_scale = 0.67

    # Calculate minimum distance to spawn new instances outside the hurted hitbox.
    # Add a 20% safe margin to the minimum distance
    var min_distance = sqrt(
        hurter.get_hurtbox().get_shape_rect().size.length_squared() +
        (hitbox.shape.get_rect().size * new_instances_scale).length_squared() / 4
    ) * 1.2

    # Helper function to create and position a new hurter instance
    var create_hurter = func(rotation_angle: float) -> void:
        # TODO: duplicate only clone export variables, not sure yet how to add the trait modifiers
        #       to the traits themselves, since this is done in the Power class
        var new_hurter: TraitInterface = hurter.duplicate()
        var new_direction = hurter.get_direction().rotated(rotation_angle)
        new_hurter.set_direction(new_direction)
        new_hurter.increment_position(new_direction * min_distance)
        new_hurter.global_scale *= new_instances_scale
        # Add new instances to the parent of the original instance
        hurter.get_parent().call_deferred("add_child", new_hurter)

    var forked_rotation: float = PI / 4
    create_hurter.call(forked_rotation)
    create_hurter.call(-forked_rotation)

    hurter.queue_free()
