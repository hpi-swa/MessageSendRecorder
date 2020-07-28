accessing
showStack: aBoolean

	showStack := aBoolean.

	self changed: #topRecords.
	self selectedRecord: self topRecords first.