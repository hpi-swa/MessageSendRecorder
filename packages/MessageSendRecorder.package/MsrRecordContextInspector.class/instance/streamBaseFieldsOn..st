fields - streaming
streamBaseFieldsOn: aStream

	aStream nextPut: self fieldSelf.
	aStream nextPut: self fieldStackTop.
	aStream nextPut: self fieldArguments.
	aStream nextPut: self fieldReturnValue.	
	aStream nextPut: self fieldAllTempVars.