class_name ProjectileZap
extends Projectile

@export var max_variation: float


func _on_change_direction_timer_timeout() -> void:
    var new_dir = c_velocity.m_direction + Vector2(randf_range(max_variation, -max_variation), randf_range(max_variation, -max_variation))
    new_dir = new_dir.normalized()
    c_velocity.set_direction(new_dir)
    rotation = new_dir.angle()
