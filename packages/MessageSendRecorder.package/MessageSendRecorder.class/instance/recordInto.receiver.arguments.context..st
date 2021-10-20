recording - callbacks
recordInto: aRecord receiver: aReceiver arguments: someArguments context: aContext
	"Evaluate all recording helpers before the call. Disable recording to avoid endless recursion for arbitrary helpers."
	
	| p |
	p := recordingProcess.
	recordingProcess := nil.
	
	(recordingHelpers at: #before) do: [:block |
		block cull: aRecord cull: aReceiver cull: someArguments cull: aContext].

	recordingProcess := p.