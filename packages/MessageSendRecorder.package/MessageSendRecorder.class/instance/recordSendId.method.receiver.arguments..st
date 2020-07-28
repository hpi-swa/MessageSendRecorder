recording - callbacks
recordSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments
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