recording - post
collectTimeRatio

	| max |
	self topRecord extension duration ifNil: [^ self].

	max := self topRecord extension ticks max: 1.

	self topRecord do: [:record |
		record extension timeRatio: record extension ticks / max].