debugger
selectRecord: aRecord

	| path |
	path := aRecord withAllParents reversed.
	path := path allButFirst: (path indexOf: self topRecord).
	path
		ifEmpty: [self selectedRecord: self topRecords first]
		ifNotEmpty: [self selectedRecordPath: path].