tree
getLabel: record

	^ String streamContents: [:s | | ttr |
		record printDetailsOn: s.
		
		s tab; space; nextPut: $#; print: record id; space; space.
		
		s tab.
		((ttr := record extension timeToRun) isNil or: [ttr < 0.001])
			ifTrue: [s nextPutAll: '  ']
			ifFalse: [
				ttr > 5
					ifTrue: [s nextPutAll: ttr asString]
					ifFalse: [ttr printOn: s showingDecimalPlaces: 3]].
				
		record extension timeRatio ifNotNil: [:ratio |
			s tab.
			ratio < 0.01 ifFalse: [
				ratio * 100 printOn: s showingDecimalPlaces: 2.
				s nextPut: $%]]].