tree - record
recordSelectedAllCopies

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args |
			record extension
				receiverCopy: rcvr copy;
				argumentCopies: (args collect: [:ea | ea copy]).]}
		after: {[:record :rcvr :args :result |
			record extension
				returnCopy: result copy]}.

	self selectedRecordChanged.