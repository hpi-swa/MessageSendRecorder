tree - record
recordSelectedAllCopies

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args :ctxt |
			record extension
				receiverCopy: rcvr copy;
				argumentCopies: (args collect: [:ea | ea copy]).]}
		after: {[:record :rcvr :args :result :ctxt |
			record extension
				returnCopy: result copy]}.

	self selectedRecordChanged.