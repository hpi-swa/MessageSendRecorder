tree
topRecords

	^ self showStack
		ifTrue: [self topRecord withAllParents allButLast]
		ifFalse: [self topRecord children]