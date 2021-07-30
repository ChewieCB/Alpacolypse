extends State
class_name PlayerState

var player: Player
var skin
var back_bounce


func _ready():
	yield(owner, "ready")
	player = owner
	skin = owner.skin
	back_bounce = owner.back_bounce

