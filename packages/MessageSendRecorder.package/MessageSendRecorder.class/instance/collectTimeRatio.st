recording - post
collectTimeRatio

	| max |
	self topRecord extension duration ifNil: [^ self].

	max := self topRecord extension duration asNanoSeconds max: 1.

	self topRecord do: [:record |
		record extension timeRatio: record extension duration asNanoSeconds / max].