tree - record
recordAllCopies

	(Project uiManager
		confirm: 'Recording copies from receivers, arguments, and\return values needs a lot of resources.\\Are you sure?' withCRs
		title: 'Really record all copies?') ifFalse: [^ self].

	self topRecord recorder
		record: #duration
		before: {[:record :rcvr :args |
			record extension
				receiverCopy: rcvr copy;
				argumentCopies: (args collect: [:ea | ea copy]).]}
		after: {[:record :rcvr :args :result |
			record extension
				returnCopy: result copy]}.

	self changed: #topRecords.