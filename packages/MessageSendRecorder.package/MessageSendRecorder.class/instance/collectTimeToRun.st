recording - post
collectTimeToRun

	self topRecord extension duration ifNil: [^ self].

	self topRecord do: [:record |
		record extension timeToRun: record extension duration asMilliSeconds].