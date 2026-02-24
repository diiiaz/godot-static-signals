extends Object
class_name StaticSignal
## A utility class providing a workaround for Godot's lack of native static signals.
##
## GDScript does not traditionally allow the [code]signal[/code] keyword to be used with the [code]static[/code] 
## modifier. This class overcomes that by dynamically registering user signals onto the 
## [StaticSignal] class object itself at runtime. 
##
## This allows for global, decoupled communication without requiring a Singleton (Autoload) 
## or a specific node instance.

## Internal counter used to ensure every dynamically created signal has a unique name.
static var _static_signal_id: int = 0

## Dynamically registers a new user signal on the StaticSignal class object.
## Returns a [Signal] object bound to this class that can be emitted or connected to globally.
## [br][br]
## [b]Usage:[/b]
## [codeblock]
## # In any class:
## static var something_happened: Signal = StaticSignal.make()
##
## # To emit:
## something_happened.emit()
##
## # To connect:
## something_happened.connect(_on_something_happened)
## [/codeblock]
static func make() -> Signal:
	# Generate a unique name to prevent signal name collisions on the class object.
	var signal_name: String = "StaticSignal-%s" % _static_signal_id
	
	# Cast the class itself to an Object to access the 'add_user_signal' method.
	var owner_class := (StaticSignal as Object)
	owner_class.add_user_signal(signal_name)
	
	_static_signal_id += 1
	
	# Return a Signal object bound to the class constant and the unique name.
	return Signal(owner_class, signal_name)
