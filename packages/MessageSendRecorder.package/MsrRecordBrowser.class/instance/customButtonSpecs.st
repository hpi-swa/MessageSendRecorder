building
customButtonSpecs
	"Inspired by Debugger."
	
	^ #(
		('Go to'		goTo		'Jump to message send with id')
		('Into'		stepInto		'step into message sends'	canStep)
		('Over'		stepOver		'step over message sends'	canStep)
		('Through'	stepThrough	'step into block'	canStep)
		('Full stack'	spawnSelectionStack	'spawn browser in stack mode')
		('Where'		showWhere		'select current message send')
		('Spawn'		spawnSelection	'spawn browser from here')
	)