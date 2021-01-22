extends State
class_name PlayerState

var player: Player
var skin


func _ready():
	yield(owner, "ready")
	player = owner
	skin = owner.skin

