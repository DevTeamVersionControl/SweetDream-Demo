# Boilerplate class to get full autocompletion and type checks for the `jello` when coding the jello's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name JelloEnemyState
extends State

# Typed reference to the jello node.
var jello : JelloEnemy


func _ready() -> void:
	# The states are children of the `JelloEnemy` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `JelloEnemy` type.
	# If the `owner` is not a `JelloEnemy`, we'll get `null`.
	jello = owner as JelloEnemy
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `JelloEnemy.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(jello != null)
