code holder
selectedMethod

	| record |
	(record := self selectedRecordParent) ifNil: [^ nil].
	record isTopRecord ifTrue: [^ nil].
	^ record method