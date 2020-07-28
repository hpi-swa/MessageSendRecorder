fields
fieldAllTempVars

	^ (self newFieldForType: #all key: #allTempVars)
		name: 'all temp vars' translated; emphasizeName;
		valueGetter: [:record | record parent printTempsAndValues]; printValueAsIs;
		yourself