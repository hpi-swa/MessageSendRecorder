fields
fieldReturnValue
	
	^ (self newFieldForType: #misc key: #returnValue)
		name: 'returnValue' translated; emphasizeName;
		valueGetter: [:record | record getReturnValue];
		yourself