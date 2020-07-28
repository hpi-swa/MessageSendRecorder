instance creation
record: method with: recorder

	^ (self canWrap: method selector inClass: method methodClass)
		ifTrue: [(self on: method selector inClass: method methodClass) setRecorder: recorder]
		ifFalse: [nil]