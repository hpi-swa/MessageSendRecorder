debugger
stepOver

	| record next |
	record := self selectedRecord.
		
	[record = self topRecord or: [(next := record getNextSibling) notNil]]
		whileFalse: [record := record parent].

	record = self topRecord
		ifTrue: [self selectRecord: self topRecords first]
		ifFalse: [self selectRecord: next].