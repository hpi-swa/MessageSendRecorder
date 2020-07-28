recording
sendMessage
	"Simulate what method wrappers would do to the outermost message send."

	| node receiver arguments method returnValue stopwatch |
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
		stopwatch := Stopwatch new.
		stopwatch activate].

	returnValue := receiver value.
	
	self recordingMode == #duration ifTrue: [
		stopwatch suspend.
		node extension duration: stopwatch duration].

	self
		recordInto: node
		return: returnValue
		receiver: receiver
		arguments: arguments
		context: thisContext.
			
	^ returnValue
