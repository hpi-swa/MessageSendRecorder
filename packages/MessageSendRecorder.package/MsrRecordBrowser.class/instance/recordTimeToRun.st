tree - record
recordTimeToRun

	self topRecord recorder
		record: #duration;
		collectTimeToRun.

	self changed: #topRecords.