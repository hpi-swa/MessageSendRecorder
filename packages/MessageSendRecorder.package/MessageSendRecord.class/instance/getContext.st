accessing - convenience
getContext

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #contextCopy) ifTrue: [
		record extension contextCopy ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #contextObject) ifTrue: [
		record extension contextObject ifNotNil: [:object |
			^ object]].
	
	^ nil