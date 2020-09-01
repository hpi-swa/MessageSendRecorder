recording - callbacks
recordInto: returningRecord return: anReturnObject receiver: aReceiverObject arguments: someArgumentObjects context: aContext
	"Evaluate all recording helpers after the call. Disable recording to avoid endless recursion for arbitrary helpers."
	
	| p |
	p := recordingProcess.
	recordingProcess := nil.

	(recordingHelpers at: #after) do: [:block |
		block value: returningRecord value: aReceiverObject value: someArgumentObjects value: anReturnObject].
	
	recordingProcess := p.