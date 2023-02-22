evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects record: record

	| startTime startTick returnValue |
	startTime := Time utcMicrosecondClock.
	startTick := Time highResClock.
	returnValue := super valueWithReceiver: anObject arguments: anArrayOfObjects record: record.
	record extension
		duration: (Duration microSeconds: Time utcMicrosecondClock - startTime);
		ticks: Time highResClock - startTick.
	^ returnValue