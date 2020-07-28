accessing - convenience
getHomeRecord

	(self extension respondsTo: #isOuterContext) ifTrue: [
		self extension isOuterContext == true ifTrue: [
			| current |
			current := self parent.
			[current isTopRecord] whileFalse: [
				current method == self method ifTrue: [^ current].
				current := current parent]]].
	
	^ self	