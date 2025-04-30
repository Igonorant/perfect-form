class_name Player
extends CharacterBody2D

@onready var c_velocity : VelocityComponent = $VelocityComponent
@onready var n_sprite : Sprite2D = $Sprite2D
@onready var scn_projectile = preload("res://projectile.tscn")

var m_screen_size # Size of the game window.
var m_flip_h : bool # Flip the player horizontally.
var m_player_input_direction : Vector2 # Player inputs direction


func _ready() -> void:
    m_screen_size = get_viewport_rect().size
    m_flip_h = false
    m_player_input_direction = Vector2.ZERO

    
func _process(_delta: float) -> void:
    _calculate_direction()
    _handle_inputs()
    _move()
    _update_sprite_direction()

   
func _calculate_direction() -> void:
    m_player_input_direction = Vector2.ZERO
    if Input.is_action_pressed("move_right"):
        m_player_input_direction.x += 1
        m_flip_h = true
    if Input.is_action_pressed("move_left"):
        m_player_input_direction.x -= 1
        m_flip_h = false
    if Input.is_action_pressed("move_down"):
        m_player_input_direction.y += 1
    if Input.is_action_pressed("move_up"):
        m_player_input_direction.y -= 1

func _handle_inputs() -> void:
    if Input.is_action_just_pressed("atk_q"):
        var projectile_instance : Projectile = scn_projectile.instantiate()
        projectile_instance.m_spawn_direction = Vector2.RIGHT * (1 if m_flip_h else -1) if velocity.is_zero_approx() else velocity
        projectile_instance.m_spawn_position = position + projectile_instance.m_spawn_direction.normalized() * 20
        projectile_instance.speed = max(velocity.length() * 3, 300)
        printt(projectile_instance.m_spawn_direction, max(velocity.length() * 5, 600)) 
        owner.add_child(projectile_instance)
    

func _move() -> void:
    c_velocity.set_direction(m_player_input_direction)
    velocity = c_velocity.get_velocity()
    move_and_slide()
    position = position.clamp(Vector2.ZERO, m_screen_size)


func _update_sprite_direction() -> void:
    n_sprite.flip_h = m_flip_h
