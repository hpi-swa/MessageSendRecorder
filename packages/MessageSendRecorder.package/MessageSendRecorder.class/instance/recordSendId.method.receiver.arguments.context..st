recording - callbacks
recordSendId: aNumber method: aCompiledMethod receiver: aReceiver arguments: someArguments context: aContext
	"Creates a new record for the message send."

	| record |
	aContext closure ifNotNil: [:closure |
		currentRecord method == closure homeMethod ifFalse: [
			record := self
				lookupSendId: -1 	"Add extra record for closure activation."
				method: aContext method "compiled block (SistaV1) or method"
				receiver: nil arguments: #()
				context: aContext.
			record extension isOuterContext: true]].

	record := self
		lookupSendId: aNumber
		method: aCompiledMethod
		receiver: aReceiver
		arguments: someArguments
		context: aContext.

	self
		recordInto: record
		receiver: aReceiver
		arguments: someArguments
		context: aContext.		
	
	^ record