recording - post
collectTimeToRun

	| threshold ticksPerMillisecond |
	self topRecord extension duration ifNil: [^ self].

	threshold := 10. "milliseconds"
	self topRecord extension duration asMilliSeconds > threshold
		ifFalse: [ticksPerMillisecond := Time highResClockTicksPerMillisecond].

	self topRecord do: [:record | | timeToRun |
		(timeToRun := record extension duration asMilliSeconds) > threshold
			ifTrue: [
				ticksPerMillisecond := record extension ticks // timeToRun.
				record extension timeToRun: timeToRun]
			ifFalse: [ "Estimate time from ticks."
				record extension timeToRun: (record extension ticks * 1000 // ticksPerMillisecond) asFloat / 1000]].