dynamic fields
removeField: name

	[ClassBuilder beSilent: true.

		self
			removeSelectorSilently: name asSimpleGetter;
			removeSelectorSilently: name asSimpleSetter;
			removeInstVarName: name.

	] ensure: [ClassBuilder beSilent: false].
		
	^ (self canUnderstand: name) not