debugger
stepThrough
	"Step over but backtrack if we can find a block activation."
	
	| record next |
	record := self selectedRecord.
	self stepOver.
	
	next := record parent
		detect: [:child | child id > record id and: [child method == record parent method
			or: [child method isCompiledBlock and: [child method homeMethod == record parent method]]]]
		ifNone: [^ self].
	next := next children first.
	
	self selectedRecord id > next id
		ifTrue: [self selectRecord: next].