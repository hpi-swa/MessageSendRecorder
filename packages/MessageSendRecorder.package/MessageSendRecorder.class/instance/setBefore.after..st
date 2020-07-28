initialization
setBefore: someBeforeBlocks after: someAfterBlocks
	"
	someBeforeBlocks ... [:record :receiver :arguments | ... ]
	someAfterBlocks ... [:record :receiver :arguments :result | ... ]
	"
	
	recordingHelpers
		at: #before put: someBeforeBlocks;
		at: #after put: someAfterBlocks.	
