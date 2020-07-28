dynamic fields
addField: name

	[ClassBuilder beSilent: true.

		self
				addInstVarName: name;
				createGetterFor: name;
				createSetterFor: name.

	] ensure: [ClassBuilder beSilent: false].
			
	^ self canUnderstand: name