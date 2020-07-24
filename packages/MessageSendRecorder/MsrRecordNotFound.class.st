Class {
	#name : #MsrRecordNotFound,
	#superclass : #Exception,
	#instVars : [
		'parentRecord',
		'expectedChildId'
	],
	#category : #'MessageSendRecorder-Support'
}

{ #category : #'priv handling' }
MsrRecordNotFound >> defaultAction [

	UnhandledError signalForException: self.
]

{ #category : #accessing }
MsrRecordNotFound >> expectedChildId [

	^ expectedChildId
]

{ #category : #accessing }
MsrRecordNotFound >> expectedChildId: anObject [

	expectedChildId := anObject.
]

{ #category : #accessing }
MsrRecordNotFound >> parentRecord [

	^ parentRecord
]

{ #category : #accessing }
MsrRecordNotFound >> parentRecord: anObject [

	parentRecord := anObject.
]
