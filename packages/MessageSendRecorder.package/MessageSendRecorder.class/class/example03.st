examples
example03
	"
	self example03.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ActiveWorld imageForm].
	
	recorder
		record: #duration
		before: {[:record :rcvr :args :ctxt |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result :ctxt |
			record extension
				returnObject: result]
		}.
	
	recorder collectTimeRatio.
	recorder collectTimeToRun.
	
	recorder topRecord explore; browse.