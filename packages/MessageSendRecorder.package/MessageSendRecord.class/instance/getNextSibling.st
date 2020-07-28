enumerating
getNextSibling

	| answerNext |
	self isTopRecord ifTrue: [^ nil].
	
	answerNext := false.
	self parent children do: [:child |
		answerNext ifTrue: [^ child].
		child == self ifTrue: [answerNext := true]].
	^ nil