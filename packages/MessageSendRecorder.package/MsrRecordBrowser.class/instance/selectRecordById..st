tree - menu
selectRecordById: id

	self topRecord do: [:record |
		record id = id ifTrue: [^ self selectRecord: record]].
	
	"Spawn new browser to look for that id."
	(self spawn: self topRecord withAllParents last) model
		selectRecordById: id.