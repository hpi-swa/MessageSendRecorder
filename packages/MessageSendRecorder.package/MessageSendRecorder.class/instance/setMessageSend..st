initialization
setMessageSend: aMessageSend
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