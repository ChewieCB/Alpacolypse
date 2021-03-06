extends KinematicBody
class_name PlayerController

onready var fadeout = $UI/Fadeout

onready var collision = $Collision
onready var default_collider = $DefaultCollisionShape
onready var slope_raycast = $SlopeRayCast
onready var impassable_raycast = $Collision/ImpassableRayCast
onready var knockback_raycasts = $Collision/KnockbackRayCasts.get_children()

onready var skin = $Collision/LlamaSkin
onready var tween = $Tween

onready var audio_player = $AudioPlayer

# Array of all things that should rotate
onready var rotateable = [
	collision,
	default_collider,
#	slope_raycast,
#	impassable_raycast,
]

onready var camera_pivot = get_node("../CameraPivot")
onready var camera = get_node("../CameraPivot/Camera")
var goal_quaternion

onready var state_machine = $StateMachine
onready var state_label = $StatusLabels/Viewport/StateLabel
onready var movement_state = $StateMachine/Movement
onready var charge_states = [
	$StateMachine/Movement/Charging,
	$StateMachine/Movement/ChargeFalling,
	$StateMachine/Movement/ChargeJumping,
	$StateMachine/Movement/Knockback
]
var is_charging = false

const SNAP_DIRECTION = Vector3.DOWN
const SNAP_LENGTH = 32

var debug_trajectory_meshes = []


func _ready():
	movement_state.connect("align_charge_cam", self, "charge_camera")
	fadeout.fade_in()


func reset():
	fadeout.fade_out_reset()
	

func _physics_process(_delta):
	is_charging = (state_machine.state in charge_states)


func charge_camera():
	# FIXME - we only want the camera rotating around the y-axis,
	# clamp it in the y vector.
	#
	# Setup a goal quat with a 20 degree angle on the z-axis
	camera_pivot = camera_pivot
	goal_quaternion = collision.global_transform.basis
	goal_quaternion *= Basis(Vector3(0, 0, 1), deg2rad(20))
	# Determine the tween time by how big the rotation is
	var rotation_time = 1 - goal_quaternion.y.angle_to(
		camera_pivot.global_transform.basis.y
	) * 0.8 + 0.1
	# Lerp camera to collision rotation
	if not camera_pivot.global_transform.basis == goal_quaternion:
		if camera_pivot.tween.is_active():
			camera_pivot.tween.stop_all()
		camera_pivot.rotate_camera(goal_quaternion, rotation_time)


func calcualate_charge_trajectory(body, impact_force, gravity=-80.0, knockback=false):
	# Array to store out trajectory points so we can draw a debug curve
	var trajectory_points = [] 
	var dt = 0.05    # time step/interval
	var time = 0
	
	# TODO - refactor this, messy!
	var target_point
	if body is Vector3:
		target_point = body
	elif body is Object:
		target_point = body.global_transform.origin
	#
	var initial_velocity = self.global_transform.origin.direction_to(
		target_point
	).normalized() * impact_force
	var initial_speed = initial_velocity.length() * 1.2
	#
	var launch_angle_deg = 15    # degrees, fix this for now
	var approach_angle_deg = 0
	
	var dummy_position = target_point
	var flung_velocity = Vector3(
		initial_speed * cos(launch_angle_deg) * cos(approach_angle_deg),
		initial_speed * sin(launch_angle_deg),
		initial_speed * cos(launch_angle_deg) * sin(approach_angle_deg)
	)
	
	# Invert for knockback
	# FIXME - this var is now inverted for some reason, we should probably fix
	# this or just rename this var to something like forwards?
	if knockback == true:
		dummy_position = self.global_transform.origin
		flung_velocity = flung_velocity.rotated(Vector3.UP, PI)
	
	# FIXME: figure out why this has a PI/16 offset?
#	var camera_rotation_offset = camera_pivot.rotation.y - PI# - (PI/16)
#
	flung_velocity = flung_velocity.rotated(
		Vector3.UP,
		collision.rotation.y + PI/2
	)
	
	var mass = 1
	
	var dummy_velocity = flung_velocity
	
	while dummy_position.y >= 0:
		# Calculate the force
		var gravity_force = Vector3(
			0, 
			-80.0,
			0
		)
		var force = gravity_force
		
		# Update the velocity
		dummy_velocity += force / mass * dt
		# Update the position
		dummy_position += dummy_velocity * dt
		# Add the dummy pos to the array
		trajectory_points.append(dummy_position)
		# Update time
		time = time + dt
	
	generate_debug_trajectory(trajectory_points, 0.25)
	
	return flung_velocity


func generate_debug_trajectory(trajectory_points, size):
	if not GlobalFlags.SHOW_DEBUG_TRAJECTORIES:
		return
	
	clear_debug_trajectory()
	# Get scene root
	var scene_root = get_tree().root.get_children()[0]
	for _point in trajectory_points:
		# Create sphere with low detail of size.
		var sphere = SphereMesh.new()
		sphere.radial_segments = 8
		sphere.rings = 8
		sphere.radius = size
		sphere.height = size * 2
		# Bright red material (unshaded).
		var material = SpatialMaterial.new()
		material.albedo_color = Color(1, 0, 0)
		material.flags_unshaded = true
		sphere.surface_set_material(0, material)
		
		# Add to meshinstance in the right place.
		var node = MeshInstance.new()
		node.mesh = sphere
		if node.is_inside_tree():
			node.global_transform.origin = _point
		scene_root.add_child(node)
		debug_trajectory_meshes.append(node)


func clear_debug_trajectory():
	for mesh in debug_trajectory_meshes:
		mesh.queue_free()
	debug_trajectory_meshes = []

