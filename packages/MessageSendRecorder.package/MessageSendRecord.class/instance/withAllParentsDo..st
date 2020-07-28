enumerating
withAllParentsDo: block

	| current |
	current := self.
	[current isTopRecord] whileFalse: [
		block value: current.
		current := current parent].
	block value: current.