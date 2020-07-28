public
recordInto: record before: someBeforeBlocks after: someAfterBlocks
	"Record additional information into a specific record."
	
	self assert: [self topRecord children notEmpty].
	self assert: [self topRecord includes: record].

	currentRecord := record.
	
	^ self
		record: #specificCall
		before: someBeforeBlocks
		after: someAfterBlocks