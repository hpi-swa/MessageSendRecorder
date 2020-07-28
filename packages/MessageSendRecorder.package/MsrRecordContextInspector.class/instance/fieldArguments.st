fields
fieldArguments
	
	^ (self newFieldForType: #misc key: #arguments)
		name: 'arguments' translated; emphasizeName;
		valueGetter: [:record | record getArguments];
		yourself