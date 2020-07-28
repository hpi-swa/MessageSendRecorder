evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects

	| context record returnValue |
	recorder shouldRecord ifFalse: [
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	context := thisContext sender "run:with:in:" sender.
	record := (recorder
		recordSendId: (numCallsBefore := numCallsBefore + 1)
		method: unwrappedMethod
		receiver: anObject
		arguments: anArrayOfObjects
		context: context).
	
	returnValue := self valueWithReceiver: anObject arguments: anArrayOfObjects record: record.

	recorder
		record: record
		return: returnValue
		receiver: anObject
		arguments: anArrayOfObjects
		context: context.
		
	^ returnValue