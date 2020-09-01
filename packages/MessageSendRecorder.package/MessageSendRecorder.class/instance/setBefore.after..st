initialization
setBefore: someBeforeBlocks after: someAfterBlocks
	"
	someBeforeBlocks ... [:record :receiver :arguments :context | ... ]
	someAfterBlocks ... [:record :receiver :arguments :result :context | ... ]
	"
	
	recordingHelpers
		at: #before put: someBeforeBlocks;
		at: #after put: someAfterBlocks.	
