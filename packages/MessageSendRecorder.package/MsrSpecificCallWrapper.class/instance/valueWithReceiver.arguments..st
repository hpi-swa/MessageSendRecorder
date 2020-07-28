evaluating
valueWithReceiver: anObject arguments: anArrayOfObjects

	| context returnValue |
	recorder shouldRecord ifFalse: [
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].
	
	numCallsBefore = 1 ifFalse: [
		numCallsBefore := numCallsBefore - 1.
		^ super valueWithReceiver: anObject arguments: anArrayOfObjects].

	numCallsBefore := numCallsBefore - 1.

	context := thisContext sender "run:with:in:" sender.
	recorder
		recordInto: record
		receiver: anObject
		arguments: anArrayOfObjects
		context: context.
	
	returnValue := super valueWithReceiver: anObject arguments: anArrayOfObjects.

	recorder
		recordInto: record
		return: returnValue
		receiver: anObject
		arguments: anArrayOfObjects
		context: context.
		
	^ returnValue