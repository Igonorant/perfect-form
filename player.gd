class_name Player
extends CharacterBody2D

@onready var c_velocity : VelocityComponent = $VelocityComponent
@onready var n_sprite : Sprite2D = $Sprite2D

var m_screen_size # Size of the game window.
var m_flip_h : bool # Flip the player horizontally.
var m_player_input_direction : Vector2 # Player inputs direction


func _ready() -> void:
    m_screen_size = get_viewport_rect().size
    m_flip_h = false
    m_player_input_direction = Vector2.ZERO

    
func _process(_delta: float) -> void:
    _calculate_direction()
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


func _move() -> void:
    c_velocity.set_direction(m_player_input_direction)
    velocity = c_velocity.get_velocity()
    move_and_slide()
    position = position.clamp(Vector2.ZERO, m_screen_size)


func _update_sprite_direction() -> void:
    n_sprite.flip_h = m_flip_h
