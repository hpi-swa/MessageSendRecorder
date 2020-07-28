recording - wrappers
createWrappers

	| wc |
	wc := self wrapperClass.

	self recordingMode == #specificCall
		ifTrue: [^ {wc on: currentRecord}].

	^ self methods
		collect: [:method | wc record: method with: self]
		thenSelect: [:wrapper | wrapper notNil]