tree - record
recordSelectedAllObjects

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result |
			record extension
				returnObject: result]}.

	self selectedRecordChanged.