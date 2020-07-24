"
A recorder for a single message send.

methods			... compiled methods to instrument for recording the message send
topRecord		... record that holds the initial message send
		
currentRecord	... when recording, this is the current one for adding children
nextRecordId	... when recording, this is the next identifying number for a new children
"
Class {
	#name : #MessageSendRecorder,
	#superclass : #Object,
	#instVars : [
		'methods',
		'topRecord',
		'currentRecord',
		'nextRecordId',
		'objectIds',
		'isFirstRecording',
		'recordingMode',
		'recordingHelpers',
		'recordingProcess'
	],
	#category : #MessageSendRecorder
}

{ #category : #examples }
MessageSendRecorder class >> example01 [
	"
	self example01.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ActiveWorld imageForm].
	recorder record: #duration.
	
	recorder collectArgumentNames.
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.
]

{ #category : #examples }
MessageSendRecorder class >> example02 [
	"
	self example02.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	"recorder setMessageSend: [ActiveWorld imageForm]."
	recorder setMessageSend: (MessageSend receiver: ActiveWorld selector: #imageForm).
	
	recorder
		record: #duration
		before: {[:record :rcvr :args |
			record extension
				argumentClasses: (args collect: [:ea | ea class])]}
		after: #().
	
	recorder collectArgumentNames.
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.
]

{ #category : #examples }
MessageSendRecorder class >> example03 [
	"
	self example03.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ActiveWorld imageForm].
	
	recorder
		record: #duration
		before: {[:record :rcvr :args |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result |
			record extension
				returnObject: result]
		}.
	
	recorder collectArgumentNames.
	recorder collectTimeRatio.
	recorder collectTimeToRun.
	
	recorder topRecord explore; browse.
]

{ #category : #examples }
MessageSendRecorder class >> example04 [
	"
	self example04.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [self example04Text asMorph fullBounds].
	
	recorder recordAllObjects.
	
	recorder collectArgumentNames.
	recorder collectTimeRatio.
	recorder collectTimeToRun.
	
	recorder topRecord explore; browse.
]

{ #category : #examples }
MessageSendRecorder class >> example04Text [

	^ (self lookupSelector: #sendMessage) getSource asText
]

{ #category : #examples }
MessageSendRecorder class >> example05 [
	"
	self example05.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [
		[[ Morph new color: Color yellow ] value ] value].
	
	recorder record: #duration.
	
	recorder collectArgumentNames.
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.
]

{ #category : #examples }
MessageSendRecorder class >> example06 [
	"
	self example06.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ 20 timesRepeat: [Morph new color: Color random] ].
	
	recorder recordAllObjects.
	
	recorder collectArgumentNames.
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.
]

{ #category : #examples }
MessageSendRecorder class >> example07 [
	"
	self example07.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ 20 timesRepeat: [Morph new color: Color random] ].
	
	recorder record.	
	recorder collectArgumentNames.
	
	recorder topRecord
		explore;
		browse.
]

{ #category : #examples }
MessageSendRecorder class >> example08 [
	"
	self example08.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ Morph new. 7 / 0 ].
	
	recorder record.	
	recorder collectArgumentNames.
	
	recorder topRecord
		explore;
		browse.
]

{ #category : #'recording - post' }
MessageSendRecorder >> collectArgumentNames [

	| map |
	map := IdentityDictionary new.

	self topRecord do: [:record |
		record extension argumentNames: (
		map at: record method ifAbsentPut: [
			(Parser new parseParameterNames: record method getSource) asArray])].
]

{ #category : #'recording - post' }
MessageSendRecorder >> collectTimeRatio [

	| max |
	self topRecord extension duration ifNil: [^ self].

	max := self topRecord extension duration asNanoSeconds max: 1.

	self topRecord do: [:record |
		record extension timeRatio: record extension duration asNanoSeconds / max].
]

{ #category : #'recording - post' }
MessageSendRecorder >> collectTimeToRun [

	self topRecord extension duration ifNil: [^ self].

	self topRecord do: [:record |
		record extension timeToRun: record extension duration asMilliSeconds].
]

{ #category : #'recording - wrappers' }
MessageSendRecorder >> createWrappers [

	| wc |
	wc := self wrapperClass.
	^ self methods
		collect: [:method | wc record: method with: self]
		thenSelect: [:wrapper | wrapper notNil]
]

{ #category : #'recording - wrappers' }
MessageSendRecorder >> createWrappersForRandom [

	^ self wrapperClassForRandom allOnRandom
]

{ #category : #accessing }
MessageSendRecorder >> currentRecord [

	^ currentRecord
]

{ #category : #accessing }
MessageSendRecorder >> currentRecord: anObject [

	currentRecord := anObject.
]

{ #category : #'recording - post' }
MessageSendRecorder >> fixDuration [
	"Collect the duration for nodes that have none."
	
	self topRecord extension duration ifNil: [^ self].

	self topRecord doLast: [:record |
		record extension duration ifNil: [
			record extension duration: (
				record children
					inject: Duration new
					into: [:all :child | all + child extension duration])]].
]

{ #category : #initialization }
MessageSendRecorder >> initialize [

	super initialize.
	
	self topRecord: (MessageSendRecord new id: 0; recorder: self; yourself).
	self methods: IdentitySet new.
	self objectIds: IdentityDictionary new.
	
	recordingHelpers := IdentityDictionary new.
	recordingHelpers at: #before put: #().
	recordingHelpers at: #after put: #().
	
	self reset.
]

{ #category : #accessing }
MessageSendRecorder >> methods [

	^ methods
]

{ #category : #accessing }
MessageSendRecorder >> methods: anObject [

	methods := anObject.
]

{ #category : #accessing }
MessageSendRecorder >> nextRecordId [

	^ nextRecordId
]

{ #category : #accessing }
MessageSendRecorder >> nextRecordId: anObject [

	nextRecordId := anObject.
]

{ #category : #recording }
MessageSendRecorder >> objectIdFor: anObject [
	"All objects that are given into this method will be held until tracing is over."
	
	| seenIds |
	seenIds := self objectIds at: anObject class ifAbsentPut: [OrderedCollection new].
	^ seenIds
		identityIndexOf: anObject identityHash
		ifAbsent: [seenIds add: anObject identityHash. seenIds size]
]

{ #category : #accessing }
MessageSendRecorder >> objectIds [

	^ objectIds
]

{ #category : #accessing }
MessageSendRecorder >> objectIds: anObject [

	objectIds := anObject.
]

{ #category : #recording }
MessageSendRecorder >> record [

	| wrappers |
	isFirstRecording := self topRecord children isEmpty.
	recordingProcess := Processor activeProcess.
	
	(wrappers := self createWrappers, self createWrappersForRandom)
		do: [:wrapper | wrapper install].

	[[^ self sendMessage]
		ensure: [
			self reset.
			wrappers do: [:wrapper | wrapper uninstall].
			self fixDuration]
	] on: MsrRecordNotFound do: [:ex |
		wrappers do: [:wrapper | wrapper uninstall].
		wrappers := #().
		self notify: ('Re-recording failed. Expected record id {1} not found during a message send for parent {2}.' format: {ex expectedChildId. ex parentRecord printDetails})
	] on: Error, Halt, Warning do: [:ex |
		wrappers do: [:wrapper | wrapper uninstall].
		wrappers := #().
		ex pass].	
	
	^ nil
]

{ #category : #recording }
MessageSendRecorder >> record: mode [

	recordingMode := mode.
	^ self record
]

{ #category : #recording }
MessageSendRecorder >> record: mode before: someBeforeBlocks after: someAfterBlocks [
	"
	mode ... #duration or #normal
	someBeforeBlocks ... [:record :receiver :arguments | ... ]
	someAfterBlocks ... [:record :receiver :arguments :result | ... ]
	"
	
	self recordingMode: mode.
	
	recordingHelpers
		at: #before put: someBeforeBlocks;
		at: #after put: someAfterBlocks.	
	
	^ self record
]

{ #category : #'recording - callbacks' }
MessageSendRecorder >> record: returningRecord return: anReturnObject receiver: aReceiverObject arguments: someArgumentObjects context: aContext [
	"Returns from a message send. Find the correct parent record to continue recording."
	
	"1) Record additional properties."
	(recordingHelpers at: #after) do: [:block |
		block value: returningRecord value: aReceiverObject value: someArgumentObjects value: anReturnObject].

	"2) Find the correct parent record. Support non-local returns."
	currentRecord == returningRecord
		ifTrue: [currentRecord := currentRecord parent]
		ifFalse: [
			currentRecord := currentRecord parent.
			[currentRecord == returningRecord] whileFalse: [
					currentRecord := currentRecord parent].	
			currentRecord := currentRecord parent].
]

{ #category : #recording }
MessageSendRecorder >> recordAllObjects [

	^ self
		record: #duration
		before: {[:record :rcvr :args |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result |
			record extension
				returnObject: result]}.
]

{ #category : #'recording - specific' }
MessageSendRecorder >> recordInto: record before: someBeforeBlocks after: someAfterBlocks [
	"Record additional information into a selected record."
	
	| wrappers |
	self assert: [self topRecord children notEmpty].
	self assert: [self topRecord includes: record].

	recordingHelpers
		at: #before put: someBeforeBlocks;
		at: #after put: someAfterBlocks.	

	recordingProcess := Processor activeProcess.
	
	(wrappers := {MsrSpecificMethodWrapper on: record}, self createWrappersForRandom)
		do: [:wrapper | wrapper install].

	[[^ self sendMessage]
		ensure: [wrappers do: [:wrapper | wrapper uninstall]]
	] on: Error, Halt, Warning do: [:ex |
		wrappers do: [:wrapper | wrapper uninstall].
		wrappers := #().
		ex pass].
]

{ #category : #'recording - specific' }
MessageSendRecorder >> recordInto: aRecord receiver: aReceiver arguments: someArguments context: aContext [

	(recordingHelpers at: #before) do: [:block |
		block value: aRecord value: aReceiver value: someArguments].

]

{ #category : #'recording - specific' }
MessageSendRecorder >> recordInto: returningRecord return: anReturnObject receiver: aReceiverObject arguments: someArgumentObjects context: aContext [

	(recordingHelpers at: #after) do: [:block |
		block value: returningRecord value: aReceiverObject value: someArgumentObjects value: anReturnObject].
]

{ #category : #'recording - callbacks' }
MessageSendRecorder >> recordSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments [
	"Creates a new record for the message send."

	| record |
	record := isFirstRecording
		ifTrue: [currentRecord children add: (MessageSendRecord new
			recorder: self;
			id: nextRecordId;
			parent: currentRecord;
			method: aCompiledMethod;
			sendId: aNumber;
			receiverClass: aReceiver class;
			receiverId: (self objectIdFor: aReceiver);
			yourself)]
		ifFalse: [currentRecord children
			detect: [:nextRecord | nextRecord id = nextRecordId]
			ifNone: [MsrRecordNotFound new
				parentRecord: currentRecord;
				expectedChildId: nextRecordId;
				signal]].

	currentRecord := record.
	nextRecordId := nextRecordId + 1.
	
	^ record
]

{ #category : #'recording - callbacks' }
MessageSendRecorder >> recordSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments context: aContext [
	"Creates a new record for the message send."

	| record |
	aContext closure ifNotNil: [:closure |
		currentRecord method == closure homeMethod ifFalse: [
"			closure outerContext ifNotNil: [:outerContext |
				outerContext closure ifNotNil: [:outerClosure |
					^ self
						recordSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments
						context: outerContext]]."
				
			record := self
				recordSendId: -1 	"Add extra record for closure activation."
				method: closure homeMethod
				receiver: nil arguments: #().
			record extension isOuterContext: true]].

	record := self
		recordSendId: aNumber
		method: aCompiledMethod
		receiver: aReceiver
		arguments: someArguments.
		
	(recordingHelpers at: #before) do: [:block |
		block value: currentRecord value: aReceiver value: someArguments].
	
	^ record
]

{ #category : #accessing }
MessageSendRecorder >> recordedProperties [
	"Answers the extra properties that will be recorded during the next send."

	^ recordedProperties
]

{ #category : #accessing }
MessageSendRecorder >> recordedProperties: someProperties [
	"See #knownProperties(Before|After|Around)Call."

	recordedProperties := someProperties.
]

{ #category : #accessing }
MessageSendRecorder >> recordingMode [
	
	^ recordingMode
]

{ #category : #accessing }
MessageSendRecorder >> recordingMode: aSymbol [
	
	recordingMode := aSymbol.
]

{ #category : #initialization }
MessageSendRecorder >> reset [
	"Reset the recorder for another recording on the same message send. Can be used to record additional properties in multiple recordings IF the message send has deterministic side effects."

	self currentRecord: self topRecord.
	self nextRecordId: self topRecord id + 1.
	
	self recordingMode: #normal.
]

{ #category : #recording }
MessageSendRecorder >> sendMessage [
	"Simulate what method wrappers would do to the outermost message send."

	| node receiver arguments method returnValue stopwatch |
	node := self topRecord.
	receiver := self topRecord parent.
	method := self topRecord method.
	arguments := #().

	(recordingHelpers at: #before) do: [:block |
		block value: node value: receiver value: arguments].

	self recordingMode == #duration ifTrue: [
		stopwatch := Stopwatch new.
		stopwatch activate].

	returnValue := self topRecord parent value.
	
	self recordingMode == #duration ifTrue: [
		stopwatch suspend.
		node extension duration: stopwatch duration].

	(recordingHelpers at: #after) do: [:block |
		block value: node value: receiver value: arguments value: returnValue].
	
	^ returnValue

]

{ #category : #initialization }
MessageSendRecorder >> setMessageSend: aMessageSend [
	"Sets the message send (or block closure) to be evaluated on recording. See #record."

	| send |
	self topRecord children ifNotEmpty: [
		self error: 'You must not change the initial send in after recording!'].
	
	aMessageSend isBlock
		ifTrue: [send := MessageSend receiver: aMessageSend selector: #value]
		ifFalse: [send := aMessageSend].
	
	self topRecord
		parent: send;
		method: (send receiver class lookupSelector: send selector);
		sendId: -1;
		receiverClass: send receiver class;
		receiverId: (self objectIdFor: send receiver).
]

{ #category : #'recording - callbacks' }
MessageSendRecorder >> shouldRecord [

	^ Processor activeProcess == recordingProcess
]

{ #category : #accessing }
MessageSendRecorder >> topRecord [

	^ topRecord
]

{ #category : #accessing }
MessageSendRecorder >> topRecord: anObject [

	topRecord := anObject.
]

{ #category : #'recording - methods' }
MessageSendRecorder >> watchClass: aClass [

	aClass theNonMetaClass methodsDo: [:method | self watchMethod: method].
	aClass theMetaClass methodsDo: [:method | self watchMethod: method].
]

{ #category : #'recording - methods' }
MessageSendRecorder >> watchMethod: aMethod [

	self methods add: aMethod.
]

{ #category : #'recording - methods' }
MessageSendRecorder >> watchPackage: aPackageInfo [

	aPackageInfo actualMethodsDo: [:method | self watchMethod: method].
]

{ #category : #'recording - methods' }
MessageSendRecorder >> watchPackageNamed: aString [

	self watchPackage: (PackageInfo named: aString).
]

{ #category : #'recording - methods' }
MessageSendRecorder >> watchSystemCategory: aSystemCategory [

	(SystemOrganization listAtCategoryNamed: aSystemCategory) do: [:className |
			self watchClass: (Smalltalk classNamed: className)].
]

{ #category : #'recording - wrappers' }
MessageSendRecorder >> wrapperClass [

	self recordingMode == #duration ifTrue: [^ MsrProfilingMethodWrapper].

	^ MsrMethodWrapper
]

{ #category : #'recording - wrappers' }
MessageSendRecorder >> wrapperClassForRandom [

	^ MsrRandomNumberWrapper
]
