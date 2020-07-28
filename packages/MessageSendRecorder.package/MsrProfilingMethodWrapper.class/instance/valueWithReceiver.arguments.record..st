evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects record: record

	| stopwatch returnValue |
	stopwatch := Stopwatch new.
	stopwatch activate.
	returnValue := super valueWithReceiver: anObject arguments: anArrayOfObjects record: record.
	stopwatch suspend.
	record extension duration: stopwatch duration.
	^ returnValue