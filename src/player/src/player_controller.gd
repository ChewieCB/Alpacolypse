extends KinematicBody

onready var camera = $Camera
onready var state_label = $StatusLabels/Viewport/StateLabel

const SNAP_DIRECTION = Vector3.DOWN
const SNAP_LENGTH = 32



