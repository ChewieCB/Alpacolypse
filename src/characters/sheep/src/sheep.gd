extends KinematicBody

onready var state_label = $StatusLabels/Viewport/StateLabel
onready var skin = $SheepSkin

export (int, 2, 100) var wander_range = 25

