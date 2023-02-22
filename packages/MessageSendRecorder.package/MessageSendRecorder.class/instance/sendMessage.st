recording
sendMessage
	"Simulate what method wrappers would do to the outermost message send."

	| node receiver arguments method returnValue startTime startTicks |
	node := self topRecord.
	receiver := self topRecord parent.
	method := self topRecord method.
	arguments := #().

	self recordingMode == #specificCall ifTrue: [
		^ receiver value].

	self
		recordInto: node
		receiver: receiver
		arguments: arguments
		context: thisContext.

	self recordingMode == #duration ifTrue: [
		startTime := Time utcMicrosecondClock.
		startTicks := Time highResClock].

	returnValue := receiver value.
	
	self recordingMode == #duration ifTrue: [
		node extension
			duration: (Duration microSeconds: Time utcMicrosecondClock - startTime);
			ticks: Time highResClock - startTicks].

	self
		recordInto: node
		return: returnValue
		receiver: receiver
		arguments: arguments
		context: thisContext.
			
	^ returnValue
