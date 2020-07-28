tree - menu
spawnStack: record

	^ ToolBuilder open: ((self class on: record)
		showStack: true;
		yourself)