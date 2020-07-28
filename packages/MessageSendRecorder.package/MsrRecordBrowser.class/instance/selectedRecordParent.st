accessing
selectedRecordParent

	^ self selectedRecord ifNotNil: [:record | record parent]