tree
getIcon: record

	^ Preferences visualExplorer
		ifTrue: [([record getReceiver iconOrThumbnailOfSize: 12] on: Error do: [nil])
			ifNil: [ToolIcons iconNamed: record receiverClass theNonMetaClass toolIcon]]
		ifFalse: [nil]
