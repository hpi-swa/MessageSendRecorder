enumerating
detect: aBlock ifNone: exceptionBlock

	self do: [:record |
		(aBlock value: record) ifTrue: [^ record]].

	^ exceptionBlock value