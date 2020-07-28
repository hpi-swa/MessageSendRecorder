accessing - convenience
getArgumentNames

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #argumentNames) ifTrue: [
		record extension argumentNames ifNotNil: [:objects |
			^ objects]].
	
	^ #()