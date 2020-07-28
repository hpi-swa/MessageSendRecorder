building
textFrame
	
	^ super textFrame
		topOffset: (self wantsOptionalButtons ifTrue: [self buttonHeight * 2] ifFalse: [self buttonHeight]);
		yourself