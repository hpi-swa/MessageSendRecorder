evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects

	recorder shouldRecord ifFalse: [
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	receiver == anObject ifFalse: [
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	self uninstall.
	
	[^ recorder
		setMessageSendArguments: anArrayOfObjects;
		record]
			ensure: [recorder topRecord browse]