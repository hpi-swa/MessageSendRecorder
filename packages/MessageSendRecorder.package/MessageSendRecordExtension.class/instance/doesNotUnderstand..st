dynamic fields
doesNotUnderstand: message

	message selector precedence
		caseOf: {
			[ 1 ] -> [ message numArgs = 0 ifTrue: [		
				(self class addField: message selector)
					ifTrue: [^ self instVarNamed: message selector] ] ].
			[ 3 ] -> [ message numArgs = 1 ifTrue: [	
				| field |
				field := message selector asSimpleGetter.
				(self class addField: field)
					ifTrue: [^ self instVarNamed: field put: message argument] ] ] }
		otherwise:  [].
	
	^ super doesNotUnderstand: message