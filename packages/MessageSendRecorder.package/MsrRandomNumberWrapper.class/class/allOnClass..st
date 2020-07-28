instance creation
allOnClass: aRandomClass

	| random |
	random := aRandomClass seed: 0.
	^ aRandomClass selectors
		select: [:selector | selector beginsWith: #next]
		thenCollect: [:selector |
			 (self on: selector inClass: aRandomClass)
				setRandom: random;
				yourself]
