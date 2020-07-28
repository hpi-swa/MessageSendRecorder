recording - post
collectArgumentNames

	| map |
	map := IdentityDictionary new.

	self topRecord do: [:record |
		record extension argumentNames: (
		map at: record method ifAbsentPut: [
			(Parser new parseParameterNames: record method getSource) asArray])].