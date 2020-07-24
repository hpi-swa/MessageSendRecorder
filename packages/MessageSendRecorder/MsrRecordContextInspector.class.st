Class {
	#name : #MsrRecordContextInspector,
	#superclass : #Inspector,
	#category : #'MessageSendRecorder-Tools'
}

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> fieldAllTempVars [

	^ (self newFieldForType: #all key: #allTempVars)
		name: 'all temp vars' translated; emphasizeName;
		valueGetter: [:record | record parent printTempsAndValues]; printValueAsIs;
		yourself
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> fieldArguments [
	
	^ (self newFieldForType: #misc key: #arguments)
		name: 'arguments' translated; emphasizeName;
		valueGetter: [:record | record getArguments];
		yourself
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> fieldReturnValue [
	
	^ (self newFieldForType: #misc key: #returnValue)
		name: 'returnValue' translated; emphasizeName;
		valueGetter: [:record | record getReturnValue];
		yourself
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> fieldSelf [

	^ super fieldSelf
		name: 'thisRecord';
		shouldStyleName: false;
		yourself
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> fieldStackTop [
	
	^ (self newFieldForType: #stackTop key: #stackTop)
		name: 'receiver' translated; emphasizeName;
		valueGetter: [:record | record getReceiver];
		yourself
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> streamBaseFieldsOn: aStream [

	aStream nextPut: self fieldSelf.
	aStream nextPut: self fieldStackTop.
	aStream nextPut: self fieldArguments.
	aStream nextPut: self fieldReturnValue.	
	aStream nextPut: self fieldAllTempVars.
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> streamInstanceVariablesOn: aStream [
	"Just show the (named) temporary variables to the list. Hide internals. The receiver is in the debugger's companion inspector."

	self streamTemporaryVariablesOn: aStream.
]

{ #category : #'as yet unclassified' }
MsrRecordContextInspector >> streamTemporaryVariablesOn: aStream [
	"Overwritten to change the visuals of temps in debuggers."
	
	| tempNames |
	tempNames := [self object parent getArgumentNames] ifError: [
		^ self streamError: 'Invalid temporaries' translated on: aStream].
	
	tempNames doWithIndex: [:name :index |
		aStream nextPut: ((self newFieldForType: #tempVar key: name)
			valueGetter: [:record | record parent getArgumentAt: index];
			yourself)].
]
