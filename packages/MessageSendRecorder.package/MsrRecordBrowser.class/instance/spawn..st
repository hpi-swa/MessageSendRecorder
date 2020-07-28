tree - menu
spawn: record

	^ ToolBuilder open: ((self class on: record)
		showStack: false;
		yourself)