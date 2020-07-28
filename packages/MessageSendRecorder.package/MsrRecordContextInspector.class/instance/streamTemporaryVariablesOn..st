fields - streaming
streamTemporaryVariablesOn: aStream
	"Overwritten to change the visuals of temps in debuggers."
	
	| tempNames |
	tempNames := [self object parent getArgumentNames] ifError: [
		^ self streamError: 'Invalid temporaries' translated on: aStream].
	
	tempNames doWithIndex: [:name :index |
		aStream nextPut: ((self newFieldForType: #tempVar key: name)
			valueGetter: [:record | record parent getArgumentAt: index];
			yourself)].