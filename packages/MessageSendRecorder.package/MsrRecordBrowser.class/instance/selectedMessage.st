code holder
selectedMessage

	| record |
	(record := self selectedRecordParent) ifNil: [^ contents := ''].
	record isTopRecord ifTrue: [
		record parent receiver isBlock
			ifTrue: [^ contents := 'DoIt\\	' withCRs, record parent receiver decompile decompileString, ' value']
			ifFalse: [^ contents := ('SendIt\\	| args |\	self perform: #{1} withArguments: args.' withCRs format: {record parent selector})]].

	^ contents := record method getSource