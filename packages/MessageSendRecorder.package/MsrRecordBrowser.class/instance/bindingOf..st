code holder - bindings
bindingOf: aString

	(self isArgument: aString)
		ifTrue: [^ aString -> (self argumentNamed: aString)].
		
	^ nil