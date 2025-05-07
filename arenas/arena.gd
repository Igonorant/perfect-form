@icon("res://assets/icons/arena.png")
class_name Arena
extends Node2D

@onready var player = $Player
@onready var m_screen_size = get_viewport_rect().size

var enemy_scene = preload("uid://dcgj84cbyh7gl") # Porcupine Scene

func _on_spawn_enemy_timer_timeout() -> void:
    var enemy = enemy_scene.instantiate()

    # Making enemy follow the player
    enemy.set_target(player)

    # Ensure a minimum distance of ~450 pixels from the player
    var distance_from_player_squared = pow(450, 2.0)
    var enemy_spawn_position = Vector2(randf_range(0.0, m_screen_size.x), randf_range(0.0, m_screen_size.y))
    while (player.global_position.distance_squared_to(enemy_spawn_position) < distance_from_player_squared):
        enemy_spawn_position = Vector2(randf_range(0.0, m_screen_size.x), randf_range(0.0, m_screen_size.y))
    enemy.global_position = enemy_spawn_position

    # Spawn the enemy
    add_child(enemy)
