tree - menu
expandPathTimeRatio
	"Show path with high time ratio."
	
	| record max |
	self topRecord extension timeRatio ifNil: [^ self].
	
	record := self selectedRecord.
	max := 1.
		
	[max >= 0.001 and: [record children notEmpty]] whileTrue: [
		| ratios |
		ratios := record children collect: [:ea | ea extension timeRatio].
		max := ratios max.
		record := record children at: (ratios indexOf: max)].

	max >= 0.001
		ifTrue: [self selectRecord: record]
		ifFalse: [self selectRecord: record parent].