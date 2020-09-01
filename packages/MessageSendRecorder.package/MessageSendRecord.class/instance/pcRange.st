accessing - convenience
pcRange
	"Answers the range in the parent record's method source."
	
	^ self isTopRecord
		ifTrue: [1 to: 0]
		ifFalse: [self parent method debuggerMap
			rangeForPC: self pc
			in: self parent method
			contextIsActiveContext: false]