public
record: mode send: aSelector to: aReceiver
	"Starts the recording when the receiver receives a message with the selector."
	
	self recordingMode: mode.
	^ self recordSend: aSelector to: aReceiver