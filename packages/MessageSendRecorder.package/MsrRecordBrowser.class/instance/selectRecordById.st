tree - menu
selectRecordById

	(Project uiManager request: 'Enter record id:')
		ifNotEmpty: [:token | self selectRecordById: token asInteger].