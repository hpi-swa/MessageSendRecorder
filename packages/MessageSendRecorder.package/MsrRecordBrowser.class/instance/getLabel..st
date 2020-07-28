tree
getLabel: record

	^ String streamContents: [:s |	
		record printDetailsOn: s.
		
		s tab; space; nextPut: $#; print: record id; space; space.
		
		s tab.
		s nextPutAll: (record extension timeToRun ifNil: ['  ']) asString.	
		
		record extension timeRatio ifNotNil: [:ratio |
			s tab.
			ratio < 0.001 ifFalse: [
				ratio * 100 printOn: s showingDecimalPlaces: 1.
				s nextPut: $%]]].