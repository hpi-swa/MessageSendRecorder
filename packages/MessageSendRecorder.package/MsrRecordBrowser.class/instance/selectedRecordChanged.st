debugger
selectedRecordChanged

	self changed: #objectChanged with: self selectedRecord.
	contextInspector update.