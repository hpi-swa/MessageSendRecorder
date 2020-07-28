recording
objectIdFor: anObject
	"All objects that are given into this method will be held until tracing is over."
	
	| seenIds |
	seenIds := self objectIds at: anObject class ifAbsentPut: [OrderedCollection new].
	^ seenIds
		identityIndexOf: anObject identityHash
		ifAbsent: [seenIds add: anObject identityHash. seenIds size]