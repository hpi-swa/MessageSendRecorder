recording - callbacks
lookupSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments context: aContext
	"Creates a new record for the message send or lookup the next one if it is a subsequent recording."

	| record |
	record := isFirstRecording
		ifTrue: [currentRecord children add: (MessageSendRecord new
			recorder: self;
			id: nextRecordId;
			parent: currentRecord;
			pc: aContext pc;
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