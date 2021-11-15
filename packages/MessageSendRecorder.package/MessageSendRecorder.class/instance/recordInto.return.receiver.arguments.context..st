recording - callbacks
recordInto: returningRecord return: anReturnObject receiver: aReceiverObject arguments: someArgumentObjects context: aContext
	"Evaluate all recording helpers after the call. Disable recording to avoid endless recursion for arbitrary helpers."
	
	| p |
	p := recordingProcess.
	recordingProcess := nil.

	(recordingHelpers at: #after) do: [:block |
		block cull: returningRecord cull: aReceiverObject cull: someArgumentObjects cull: anReturnObject cull: aContext].
	
	recordingProcess := p.