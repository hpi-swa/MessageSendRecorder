Class {
	#name : #MsrSpecificMethodWrapper,
	#superclass : #MwMethodWrapper,
	#instVars : [
		'recorder',
		'record',
		'numCallsBefore',
		'unwrappedMethod'
	],
	#category : #'MessageSendRecorder-Support'
}

{ #category : #'instance creation' }
MsrSpecificMethodWrapper class >> on: record [

	^ (self on: record selector inClass: record receiverClass)
		setRecord: record;
		yourself
]

{ #category : #installation }
MsrSpecificMethodWrapper >> install [

	super install.
	unwrappedMethod := self unwrappedMethod.
]

{ #category : #accessing }
MsrSpecificMethodWrapper >> numCallsBefore [

	^ numCallsBefore
]

{ #category : #accessing }
MsrSpecificMethodWrapper >> recorder [

	^ recorder
]

{ #category : #initialization }
MsrSpecificMethodWrapper >> setRecord: aRecord [

	recorder := aRecord recorder.
	record := aRecord.
	numCallsBefore := aRecord sendId.
]

{ #category : #'as yet unclassified' }
MsrSpecificMethodWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [

	| context returnValue |
	recorder shouldRecord ifFalse: [
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	numCallsBefore = 1 ifFalse: [
		numCallsBefore := numCallsBefore - 1.
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].

	numCallsBefore := numCallsBefore - 1.

	context := thisContext sender "run:with:in:" sender.
	recorder
		recordInto: record
		receiver: anObject
		arguments: anArrayOfObjects
		context: context.
	
	returnValue := super valueWithReceiver: anObject arguments: anArrayOfObjects.

	recorder
		recordInto: record
		return: returnValue
		receiver: anObject
		arguments: anArrayOfObjects
		context: context.
		
	^ returnValue
]
