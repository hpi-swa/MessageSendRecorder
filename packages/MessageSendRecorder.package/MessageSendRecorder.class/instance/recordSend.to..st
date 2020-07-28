public
recordSend: aSelector to: aReceiver
	"Starts the recording when the receiver receives a message with the selector."
	
	self setMessageSend: (MessageSend receiver: aReceiver selector: aSelector).
	
	recordingProcess := Processor activeProcess.
	
	^ (MsrSpecificReceiverWrapper on: self topRecord)
		install;
		yourself