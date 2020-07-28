initialization
setRecordAllObjects
	"Hold on to all object pointers for receivers, arguments, and return values."
	
	self setBefore: {[:record :rcvr :args |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result |
			record extension
				returnObject: result]}.