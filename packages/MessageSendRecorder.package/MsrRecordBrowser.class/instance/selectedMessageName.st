code holder
selectedMessageName

	^ self selectedRecordParent ifNotNil: [:r | r method selector]