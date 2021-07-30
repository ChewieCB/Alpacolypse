extends State
class_name SheepState

var sheep: Sheep
var skin
var rigid_skin
var nav: Navigation
var player: Player
var sheep_rigid: RigidBody
var idle_timer: Timer
var graze_timer: Timer
var rigid_timer: Timer
var tween: Tween
var floor_cast: RayCast


func _ready():
	yield(owner, "ready")
	sheep = owner
	skin = owner.skin
	rigid_skin = owner.rigid_skin
	nav = owner.nav
	player = owner.player
	sheep_rigid = owner.sheep_rigid
	idle_timer = owner.idle_timer
	graze_timer = owner.graze_timer
	rigid_timer = owner.rigid_timer
	tween = owner.tween
	floor_cast = owner.floor_cast

