"
This is a record of a sent message. It holds on to the compiled method and stores also a little bit information about the receiver. A recorded message send points to its parent record, which (indirectly represents the actual sender. Records can have children, which are the message sends that happened when evaluating the compiled method.

recorder	... recording context in which the record tree can be extended

id 				... identifying number of this record, local to the record tree
parent 		... record that represents the sender
children 	... records of sends that happened then evaluating the method

method	... compiled method that was called during this send
sendId 		... identifying number of the send, local to the method in the record tree

receiverClass	... class of the message receiver
receiverId		... identifying number of the receiver, local to the record tree

extension		... additional information about this send, maybe expensive to hold on for too long ;-)
"
Class {
	#name : #MessageSendRecord,
	#superclass : #Object,
	#instVars : [
		'recorder',
		'id',
		'parent',
		'children',
		'method',
		'sendId',
		'receiverClass',
		'receiverId',
		'extension'
	],
	#category : #MessageSendRecorder
}

{ #category : #tools }
MessageSendRecord >> browse [

	^ MsrRecordBrowser openOn: self
]

{ #category : #accessing }
MessageSendRecord >> children [

	^ children
]

{ #category : #accessing }
MessageSendRecord >> children: anObject [

	children := anObject.
]

{ #category : #enumerating }
MessageSendRecord >> detect: aBlock [

	^ self detect: aBlock ifNone: nil
]

{ #category : #enumerating }
MessageSendRecord >> detect: aBlock ifNone: exceptionBlock [

	self do: [:record |
		(aBlock value: record) ifTrue: [^ record]].

	^ exceptionBlock value
]

{ #category : #enumerating }
MessageSendRecord >> do: block [

	self doFirst: block.
]

{ #category : #enumerating }
MessageSendRecord >> doFirst: block [

	block value: self.
	
	self children do: [:node |
		node doFirst: block].
]

{ #category : #enumerating }
MessageSendRecord >> doLast: block [

	self children do: [:node |
		node doLast: block].
	
	block value: self.
]

{ #category : #accessing }
MessageSendRecord >> extension [

	^ extension
]

{ #category : #accessing }
MessageSendRecord >> extension: anObject [

	extension := anObject.
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getArgumentAt: argIndex [

	| record |
	record := self getHomeRecord.
		
	(record extension respondsTo: #argumentCopies) ifTrue: [
		record extension argumentCopies ifNotNil: [:objects |
			^ objects at: argIndex]].
	
	(record extension respondsTo: #argumentObjects) ifTrue: [
		record extension argumentObjects ifNotNil: [:objects |
			^ objects at: argIndex]].
	
	(record extension respondsTo: #argumentClasses) ifTrue: [
		record extension argumentClasses ifNotNil: [:objects |
			| argClass |
			argClass := objects at: argIndex.
			^ [argClass new] ifError: [argClass someInstance]]].

	^ nil

]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getArgumentNamed: name [
	
	^ self getArgumentAt: (self getArgumentNames indexOf: name)
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getArgumentNames [

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #argumentNames) ifTrue: [
		record extension argumentNames ifNotNil: [:objects |
			^ objects]].
	
	^ #()
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getArguments [

	| record |
	record := self getHomeRecord.
		
	(record extension respondsTo: #argumentCopies) ifTrue: [
		record extension argumentCopies ifNotNil: [:objects |
			^ objects]].
	
	(record extension respondsTo: #argumentObjects) ifTrue: [
		record extension argumentObjects ifNotNil: [:objects |
			^ objects]].
	
	(record extension respondsTo: #argumentClasses) ifTrue: [
		record extension argumentClasses ifNotNil: [:objects |
			^ objects collect: [:argClass | [argClass new] ifError: [argClass someInstance]]]].

	^ #()

]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getContext [

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #contextCopy) ifTrue: [
		record extension contextCopy ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #contextObject) ifTrue: [
		record extension contextObject ifNotNil: [:object |
			^ object]].
	
	^ nil
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getHomeRecord [

	(self extension respondsTo: #isOuterContext) ifTrue: [
		self extension isOuterContext == true ifTrue: [
			| current |
			current := self parent.
			[current isTopRecord] whileFalse: [
				current method == self method ifTrue: [^ current].
				current := current parent]]].
	
	^ self	
]

{ #category : #enumerating }
MessageSendRecord >> getNextSibling [

	| answerNext |
	self isTopRecord ifTrue: [^ nil].
	
	answerNext := false.
	self parent children do: [:child |
		answerNext ifTrue: [^ child].
		child == self ifTrue: [answerNext := true]].
	^ nil
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getReceiver [

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #receiverCopy) ifTrue: [
		record extension receiverCopy ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #receiverObject) ifTrue: [
		record extension receiverObject ifNotNil: [:object |
			^ object]].
	
	^ [record receiverClass new] ifError: [record receiverClass someInstance]
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> getReturnValue [

	| record |
	record := self getHomeRecord.

	(record extension respondsTo: #returnCopy) ifTrue: [
		record extension returnCopy ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #returnObject) ifTrue: [
		record extension returnObject ifNotNil: [:object |
			^ object]].
	
	(record extension respondsTo: #returnClass) ifTrue: [
		record extension returnClass ifNotNil: [:returnClass |
			^ [returnClass new] ifError: [returnClass someInstance]]].
	
	^ nil
]

{ #category : #accessing }
MessageSendRecord >> id [

	^ id
]

{ #category : #accessing }
MessageSendRecord >> id: anObject [

	id := anObject.
]

{ #category : #enumerating }
MessageSendRecord >> includes: someRecord [

	self do: [:record | someRecord == record ifTrue: [^ true]].

	^ false
]

{ #category : #initialization }
MessageSendRecord >> initialize [

	super initialize.
	
	children := OrderedCollection new.
	extension := MessageSendRecordExtension new.
]

{ #category : #testing }
MessageSendRecord >> isTopRecord [
	"I am the top record if my parent is the initial message send that produced this record tree."

	"^ self id = 0"
	^ self parent isMessageSend
]

{ #category : #accessing }
MessageSendRecord >> method [

	^ method
]

{ #category : #accessing }
MessageSendRecord >> method: anObject [

	method := anObject.
]

{ #category : #accessing }
MessageSendRecord >> parent [

	^ parent
]

{ #category : #accessing }
MessageSendRecord >> parent: anObject [

	parent := anObject.
]

{ #category : #printing }
MessageSendRecord >> printDetails [

	^ String streamContents: [:s | self printDetailsOn: s]
]

{ #category : #printing }
MessageSendRecord >> printDetailsOn: s [

	self extension isOuterContext == true
		ifTrue: [
			s nextPutAll: '[] in '.
			s nextPutAll: self method methodClass name]
		ifFalse: [
			s nextPutAll: self receiverClass name.
			self method methodClass = self receiverClass
				ifFalse: [s nextPut: $(; nextPutAll: self method methodClass name; nextPut: $)]].
				
	s nextPutAll: '>>'.
	s nextPutAll: self method selector asString.

]

{ #category : #printing }
MessageSendRecord >> printOn: stream [

	super printOn: stream.
	stream nextPut: $(; print: id; nextPut: $).
]

{ #category : #printing }
MessageSendRecord >> printTempsAndValues [

	^ String streamContents: [:s |
		self printTempsAndValuesOn: s]

]

{ #category : #printing }
MessageSendRecord >> printTempsAndValuesOn: s [

	| names values |
	names := self getArgumentNames.
	values := self getArguments.
	names size = values size ifFalse: [^ self].
	
	names with: values do: [:name :object |
		s nextPutAll: name; nextPutAll: ': '; tab; print: object; cr].
]

{ #category : #accessing }
MessageSendRecord >> receiverClass [

	^ receiverClass
]

{ #category : #accessing }
MessageSendRecord >> receiverClass: anObject [

	receiverClass := anObject.
]

{ #category : #accessing }
MessageSendRecord >> receiverId [

	^ receiverId
]

{ #category : #accessing }
MessageSendRecord >> receiverId: anObject [

	receiverId := anObject.
]

{ #category : #accessing }
MessageSendRecord >> recorder [

	^ recorder
]

{ #category : #accessing }
MessageSendRecord >> recorder: anObject [

	recorder := anObject.
]

{ #category : #'accessing - convenience' }
MessageSendRecord >> selector [

	^ self method selector
]

{ #category : #accessing }
MessageSendRecord >> sendId [

	^ sendId
]

{ #category : #accessing }
MessageSendRecord >> sendId: anObject [

	sendId := anObject.
]

{ #category : #enumerating }
MessageSendRecord >> withAllParents [

	^ Array streamContents: [:s |
			self withAllParentsDo: [:record | s nextPut: record]]
]

{ #category : #enumerating }
MessageSendRecord >> withAllParentsDo: block [

	| current |
	current := self.
	[current isTopRecord] whileFalse: [
		block value: current.
		current := current parent].
	block value: current.
]
