Class {
	#name : #MessageSendRecordExtension,
	#superclass : #Object,
	#instVars : [
		'duration',
		'argumentClasses',
		'argumentNames',
		'timeRatio',
		'receiverObject',
		'argumentObjects',
		'returnObject',
		'timeToRun',
		'isOuterContext',
		'receiverCopy',
		'argumentCopies',
		'returnCopy'
	],
	#category : #MessageSendRecorder
}

{ #category : #'dynamic fields' }
MessageSendRecordExtension class >> addField: name [

	[ClassBuilder beSilent: true.

		self
				addInstVarName: name;
				createGetterFor: name;
				createSetterFor: name.

	] ensure: [ClassBuilder beSilent: false].
			
	^ self canUnderstand: name
]

{ #category : #'dynamic fields' }
MessageSendRecordExtension class >> removeAllFields [

	self instVarNames do: [:field | self removeField: field].
	self organization removeEmptyCategories.
]

{ #category : #'dynamic fields' }
MessageSendRecordExtension class >> removeField: name [

	[ClassBuilder beSilent: true.

		self
			removeSelectorSilently: name asSimpleGetter;
			removeSelectorSilently: name asSimpleSetter;
			removeInstVarName: name.

	] ensure: [ClassBuilder beSilent: false].
		
	^ (self canUnderstand: name) not
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentClasses [

	^ argumentClasses
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentClasses: anObject [

	argumentClasses := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentCopies [

	^ argumentCopies
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentCopies: anObject [

	argumentCopies := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentNames [

	^ argumentNames
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentNames: anObject [

	argumentNames := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentObjects [

	^ argumentObjects
]

{ #category : #accessing }
MessageSendRecordExtension >> argumentObjects: anObject [

	argumentObjects := anObject.
]

{ #category : #'dynamic fields' }
MessageSendRecordExtension >> doesNotUnderstand: message [

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
]

{ #category : #accessing }
MessageSendRecordExtension >> duration [

	^ duration
]

{ #category : #accessing }
MessageSendRecordExtension >> duration: anObject [

	duration := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> isOuterContext [

	^ isOuterContext
]

{ #category : #accessing }
MessageSendRecordExtension >> isOuterContext: anObject [

	isOuterContext := anObject.
]

{ #category : #printing }
MessageSendRecordExtension >> printOn: stream [

	stream nextPut: ${; space.
	
	self class instVarNames
		do: [:instVarName |
			stream
				nextPut: $#;
				nextPutAll: instVarName;
				nextPutAll: ' -> ';
				print: (self instVarNamed: instVarName)]
		separatedBy: [
			stream
				nextPutAll: ' . '].
			
	stream space; nextPut: $}.
]

{ #category : #accessing }
MessageSendRecordExtension >> receiverCopy [

	^ receiverCopy
]

{ #category : #accessing }
MessageSendRecordExtension >> receiverCopy: anObject [

	receiverCopy := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> receiverObject [

	^ receiverObject
]

{ #category : #accessing }
MessageSendRecordExtension >> receiverObject: anObject [

	receiverObject := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> returnCopy [

	^ returnCopy
]

{ #category : #accessing }
MessageSendRecordExtension >> returnCopy: anObject [

	returnCopy := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> returnObject [

	^ returnObject
]

{ #category : #accessing }
MessageSendRecordExtension >> returnObject: anObject [

	returnObject := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> timeRatio [

	^ timeRatio
]

{ #category : #accessing }
MessageSendRecordExtension >> timeRatio: anObject [

	timeRatio := anObject.
]

{ #category : #accessing }
MessageSendRecordExtension >> timeToRun [

	^ timeToRun
]

{ #category : #accessing }
MessageSendRecordExtension >> timeToRun: anObject [

	timeToRun := anObject.
]
