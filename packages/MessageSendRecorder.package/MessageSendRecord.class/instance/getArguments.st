accessing - convenience
getArguments

	| record |
	record := self getHomeRecord.
		
	(record extension respondsTo: #argumentCopies) ifTrue: [
		record extension argumentCopies ifNotNil: [:objects |
			^ objects]].
	
	(record extension respondsTo: #argumentObjects) ifTrue: [
		record extension argumentObjects ifNotNil: [:objects |
			^ objects]].
	
	(record extension respondsTo: #argumentClasses) ifTrue: [
		record extension argumentClasses ifNotNil: [:objects |
			^ objects collect: [:argClass | [argClass new] ifError: [argClass someInstance]]]].

	^ #()
