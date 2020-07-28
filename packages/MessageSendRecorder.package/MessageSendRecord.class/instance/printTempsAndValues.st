printing
printTempsAndValues

	^ String streamContents: [:s |
		self printTempsAndValuesOn: s]
