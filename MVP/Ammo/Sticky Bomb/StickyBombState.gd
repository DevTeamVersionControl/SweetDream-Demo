# Boilerplate class to get full autocompletion and type checks for the `sticky bomb` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name StickyBombState
extends State

# Typed reference to the player node.
var sticky_bomb : StickyBomb


func _ready() -> void:
	# The states are children of the `Sticky bomb` node so their `_ready()` callback will execute first.
	# That's why we wait for the `owner` to be ready first.
	yield(owner, "ready")
	# The `as` keyword casts the `owner` variable to the `Sticky bomb` type.
	# If the `owner` is not a `Player`, we'll get `null`.
	sticky_bomb = owner as StickyBomb
	# This check will tell us if we inadvertently assign a derived state script
	# in a scene other than `StickyBomb.tscn`, which would be unintended. This can
	# help prevent some bugs that are difficult to understand.
	assert(sticky_bomb != null)
