class_name Player
extends CharacterBody2D

@onready var c_velocity : VelocityComponent = $VelocityComponent
@onready var n_sprite : Sprite2D = $Sprite2D
@onready var scn_projectile = preload("res://traits/projectile.tscn")

var m_player_input_direction : Vector2 # Player inputs direction
var m_player_last_input_direction : Vector2 # Player last inputs direction


func _ready() -> void:
    m_player_input_direction = Vector2.ZERO
    m_player_last_input_direction = Vector2.ZERO

    
func _process(_delta: float) -> void:
    _calculate_direction()
    _handle_inputs()
    _move()
    _update_sprite_direction()

   
func _calculate_direction() -> void:
    m_player_input_direction = Vector2.ZERO
    m_player_input_direction.x = Input.get_axis("move_left", "move_right");
    m_player_input_direction.y = Input.get_axis("move_up", "move_down");
    if (!m_player_input_direction.is_zero_approx()):
        m_player_last_input_direction = m_player_input_direction


func _handle_inputs() -> void:
    if Input.is_action_just_pressed("atk_q"):
        _spawn_projectile()


func _spawn_projectile() -> void:
    var projectile_instance : Projectile = scn_projectile.instantiate()
    if (velocity.is_zero_approx()):
        projectile_instance.m_spawn_direction = m_player_last_input_direction.normalized()
    else:
        projectile_instance.m_spawn_direction = velocity.normalized()
    projectile_instance.m_spawn_position = position + projectile_instance.m_spawn_direction * 20
    projectile_instance.speed = max(velocity.length() * 3, 300)
    owner.add_child(projectile_instance)


func _move() -> void:
    c_velocity.set_direction(m_player_input_direction)
    velocity = c_velocity.get_velocity()
    move_and_slide()


func _update_sprite_direction() -> void:
    # This needs to be a little bit complex to avoid flipping the sprite when input direction is 0.
    if (n_sprite.flip_h):
        if (m_player_input_direction.x < 0.0):
            n_sprite.flip_h = false
    elif (m_player_input_direction.x > 0.0):
        n_sprite.flip_h = true
