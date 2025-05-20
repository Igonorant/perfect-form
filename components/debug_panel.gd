@icon("res://assets/icons/external/pixel-boy/control/icon_text_panel.png")
class_name DebugPanel
extends PanelContainer

@onready var _parent: Node = get_parent()
@onready var _label: Label = %Label
@onready var _offset: Vector2 = position

var _position_provider: Node = null

func _ready() -> void:
    _position_provider = _parent
    while (_position_provider is not Node2D):
        _position_provider = _position_provider.get_parent()
        if (_position_provider == get_tree()):
            break

func _physics_process(_delta: float) -> void:
    if _parent == null:
        return
    global_position = _position_provider.global_position + _offset

    if _parent.has_method("_to_string"):
        _label.text = _parent._to_string()
