tree - record
recordSelectedTimeToRun

	| stopwatch |
	stopwatch := Stopwatch new.

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args :ctxt |
			stopwatch activate]}
		after: {[:record :rcvr :args :result :ctxt |
			stopwatch suspend.
			record extension timeToRun: stopwatch duration asMilliSeconds.
			stopwatch reset]}.

	self selectedRecordChanged.