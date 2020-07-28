accessing - convenience
getReceiver

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #receiverCopy) ifTrue: [
		record extension receiverCopy ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #receiverObject) ifTrue: [
		record extension receiverObject ifNotNil: [:object |
			^ object]].
	
	^ [record receiverClass new] ifError: [record receiverClass someInstance]