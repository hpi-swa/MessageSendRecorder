recording - callbacks
recordSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments context: aContext
	"Creates a new record for the message send."

	| record |
	aContext closure ifNotNil: [:closure |
		currentRecord method == closure homeMethod ifFalse: [
			record := self
				recordSendId: -1 	"Add extra record for closure activation."
				method: closure homeMethod
				receiver: nil arguments: #().
			record extension isOuterContext: true]].

	record := self
		recordSendId: aNumber
		method: aCompiledMethod
		receiver: aReceiver
		arguments: someArguments.

	self
		recordInto: record
		receiver: aReceiver
		arguments: someArguments
		context: aContext.		
	
	^ record