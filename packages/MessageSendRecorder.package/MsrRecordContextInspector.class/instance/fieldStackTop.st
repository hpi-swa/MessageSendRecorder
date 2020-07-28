fields
fieldStackTop
	
	^ (self newFieldForType: #stackTop key: #stackTop)
		name: 'receiver' translated; emphasizeName;
		valueGetter: [:record | record getReceiver];
		yourself