accessing
selectedRecord: anObject

	selectedRecord := anObject.
	
	self changed: #selectedRecord.
	self contentsChanged.
	
	receiverInspector object: (selectedRecord ifNotNil: [:r | r parent getReceiver]).
	contextInspector object: selectedRecord.