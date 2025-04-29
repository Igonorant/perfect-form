extends CharacterBody2D

var m_screen_size # Size of the game window.
var m_flip_h : bool # Flip the player horizontally.
var c_velocity : VelocityComponent

func _ready():
	m_screen_size = get_viewport_rect().size
	c_velocity = $VelocityComponent
	m_flip_h = false
	
func _process(delta):
	var direction : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		m_flip_h = true
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		m_flip_h = false
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	c_velocity.set_direction(direction)
	
	var l_velocity : Vector2 = c_velocity.get_velocity()
	
	$Sprite2D.flip_h = m_flip_h

	position += l_velocity * delta
	position = position.clamp(Vector2.ZERO, m_screen_size)
