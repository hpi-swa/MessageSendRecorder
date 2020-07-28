tree
getHelp: record

	^ String streamContents: [:s |
		record printDetailsOn: s.
		s cr.
		record printTempsAndValuesOn: s]