accessing - convenience
getArgumentNamed: name
	
	^ self getArgumentAt: (self getArgumentNames indexOf: name)