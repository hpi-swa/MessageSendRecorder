printing
printTempsAndValuesOn: s

	| names values |
	names := self getArgumentNames.
	values := self getArguments.
	names size = values size ifFalse: [^ self].
	
	names with: values do: [:name :object |
		s nextPutAll: name; nextPutAll: ': '; tab; print: object; cr].