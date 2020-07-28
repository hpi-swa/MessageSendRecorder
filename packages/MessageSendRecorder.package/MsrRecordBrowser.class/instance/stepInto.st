debugger
stepInto

	self selectedRecord children
		ifNotEmpty: [:children | self selectRecord: children first]
		ifEmpty: [self stepOver].