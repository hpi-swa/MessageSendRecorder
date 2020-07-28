debugger
stepThrough
	"Step over but backtrack if we can find a block activation."
	
	| record next |
	record := self selectedRecord.
	self stepOver.
	
	next := record parent
		detect: [:child | child method == record parent method and: [child id > record id]]
		ifNone: [^ self].
	next := next children first.
	
	self selectedRecord id > next id
		ifTrue: [self selectRecord: next].