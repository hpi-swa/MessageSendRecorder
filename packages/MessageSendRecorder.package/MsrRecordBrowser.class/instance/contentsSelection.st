code holder
contentsSelection

	| selector tokens start stop bodyStart |
	self flag: #todo. "mt: Block activation not selected correctly."
	
	^ self selectedRecord
		ifNil: [1 to: 0]
		ifNotNil: [:record | record pcRange].


	
	"bodyStart := (contents asString findString: String cr) + 1.
	
	self selectedRecord extension isOuterContext == true
		ifFalse: [selector := self selectedRecord method selector]
		ifTrue: [selector := #value].
	
	selector last == $: ifFalse: [
		^ (0 to: selector size - 1) + (contents asString findString: selector startingAt: bodyStart)].
	
	tokens := selector findTokens: ':'.
	tokens := tokens collect: [:ea | ea, ':'].
	
	start := contents asString findString: tokens first startingAt: bodyStart.
	
	tokens size = 1
		ifTrue: [
			stop := start + tokens first size - 1]
		ifFalse: [
			stop := contents asString findString: tokens last startingAt: start + tokens first size.
			stop := stop + tokens last size - 1].
	
	^ start to: stop"