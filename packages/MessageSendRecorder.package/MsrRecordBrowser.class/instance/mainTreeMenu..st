tree - menu
mainTreeMenu: aMenu 
	<treeMenu>
	
	aMenu addList: #(
		('step into (e)'			stepInto)
		('step over (t)'			stepOver)
		('step through (T)'	stepThrough)
		-
		('go to... (p)'			goTo)
		('spawn (r)'			spawnSelection)
		('spawn stack (f)'	spawnSelectionStack)
		-
		('collect time ratio' collectTimeRatio)
		('collect time to run' collectTimeToRun)
		-
		('expand high ratio'	expandPathTimeRatio)
		-
		('record here time to run' recordSelectedTimeToRun)
		('record here all objects'	recordSelectedAllObjects	'Collect references of receiver, arguments, and return value.')
		('record here all copies'	recordSelectedAllCopies	'Collect copies of receiver, arguments, and return value.')
		-
		('record time to run' recordTimeToRun)
		('record all objects'	recordAllObjects	'Collect references of receiver, arguments, and return value.')
		('record all copies'	recordAllCopies	'Collect copies of receiver, arguments, and return value.')
		-
		('browse source (b)'		browseSelection)
		('explore record'		exploreSelection)
	).
			
	^ aMenu