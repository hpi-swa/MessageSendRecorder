printing
printOn: stream

	stream nextPut: ${; space.
	
	self class instVarNames
		do: [:instVarName |
			stream
				nextPut: $#;
				nextPutAll: instVarName;
				nextPutAll: ' -> ';
				print: (self instVarNamed: instVarName)]
		separatedBy: [
			stream
				nextPutAll: ' . '].
			
	stream space; nextPut: $}.