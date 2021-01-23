extends State
class_name SheepState

var sheep: Sheep
var skin
var nav: Navigation
var player: Player
var sheep_rigid: RigidBody
var idle_timer: Timer
var graze_timer: Timer
var tween: Tween


func _ready():
	yield(owner, "ready")
	sheep = owner
	skin = owner.skin
	nav = owner.nav
	
	player = owner.player
	sheep_rigid = owner.sheep_rigid
	
	idle_timer = owner.idle_timer
	graze_timer = owner.graze_timer
	
	tween = owner.tween

