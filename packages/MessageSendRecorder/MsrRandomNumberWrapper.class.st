Class {
	#name : #MsrRandomNumberWrapper,
	#superclass : #MwMethodWrapper,
	#instVars : [
		'random',
		'unwrappedMethod'
	],
	#category : #'MessageSendRecorder-Support'
}

{ #category : #'instance creation' }
MsrRandomNumberWrapper class >> allOnClass: aRandomClass [

	| random |
	random := aRandomClass seed: 0.
	^ aRandomClass selectors
		select: [:selector | selector beginsWith: #next]
		thenCollect: [:selector |
			 (self on: selector inClass: aRandomClass)
				setRandom: random;
				yourself]

]

{ #category : #'instance creation' }
MsrRandomNumberWrapper class >> allOnRandom [

	^ self allOnClass: Random
]

{ #category : #installation }
MsrRandomNumberWrapper >> install [

	super install.
	unwrappedMethod := self unwrappedMethod.
]

{ #category : #initialization }
MsrRandomNumberWrapper >> setRandom: anObject [

	random := anObject.
]

{ #category : #evaluating }
MsrRandomNumberWrapper >> valueWithReceiver: anObject arguments: anArrayOfObjects [

	^ random withArgs: anArrayOfObjects executeMethod: unwrappedMethod
]
