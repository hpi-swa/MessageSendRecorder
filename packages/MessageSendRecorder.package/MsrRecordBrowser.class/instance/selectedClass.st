code holder
selectedClass

	^ self selectedRecordParent ifNotNil: [:r | r method methodClass]