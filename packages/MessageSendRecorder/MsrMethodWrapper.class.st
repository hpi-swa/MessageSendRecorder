Class {
	#name : #MsrMethodWrapper,
	#superclass : #MwMethodWrapper,
	#instVars : [
		'recorder',
		'numCallsBefore',
		'unwrappedMethod'
	],
	#category : #'MessageSendRecorder-Support'
}

{ #category : #'instance creation' }
MsrMethodWrapper class >> record: method with: recorder [

	^ (self canWrap: method selector inClass: method methodClass)
		ifTrue: [(self on: method selector inClass: method methodClass) setRecorder: recorder]
		ifFalse: [nil]
]

{ #category : #installation }
MsrMethodWrapper >> install [

	super install.
	unwrappedMethod := self unwrappedMethod.
]

{ #category : #accessing }
MsrMethodWrapper >> numCallsBefore [

	^ numCallsBefore
]

{ #category : #accessing }
MsrMethodWrapper >> recorder [

	^ recorder
]

{ #category : #initialization }
MsrMethodWrapper >> setRecorder: aRecorder [

	recorder := aRecorder.
	numCallsBefore := 0.
]

{ #category : #evaluating }
MsrMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [

	| context record returnValue |
	recorder shouldRecord ifFalse: [
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	context := thisContext sender "run:with:in:" sender.
	record := (recorder
		recordSendId: (numCallsBefore := numCallsBefore + 1)
		method: unwrappedMethod
		receiver: anObject
		arguments: anArrayOfObjects
		context: context).
	
	returnValue := self valueWithReceiver: anObject arguments: anArrayOfObjects record: record.

	recorder
		record: record
		return: returnValue
		receiver: anObject
		arguments: anArrayOfObjects
		context: context.
		
	^ returnValue
]

{ #category : #evaluating }
MsrMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects record: record [

	^ super valueWithReceiver: anObject arguments: anArrayOfObjects
]
