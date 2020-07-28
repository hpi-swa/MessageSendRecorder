enumerating
doFirst: block

	block value: self.
	
	self children do: [:node |
		node doFirst: block].