enumerating
doLast: block

	self children do: [:node |
		node doLast: block].
	
	block value: self.