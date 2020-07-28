enumerating
includes: someRecord

	self do: [:record | someRecord == record ifTrue: [^ true]].

	^ false