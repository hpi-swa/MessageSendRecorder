tree - record
recordSelectedAllObjects

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args :ctxt |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result :ctxt |
			record extension
				returnObject: result]}.

	self selectedRecordChanged.