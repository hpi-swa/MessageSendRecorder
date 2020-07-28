accessing - convenience
getReturnValue

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #returnCopy) ifTrue: [
		record extension returnCopy ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #returnObject) ifTrue: [
		record extension returnObject ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #returnClass) ifTrue: [
		record extension returnClass ifNotNil: [:returnClass |
			^ [returnClass new] ifError: [returnClass someInstance]]].
	
	^ nil