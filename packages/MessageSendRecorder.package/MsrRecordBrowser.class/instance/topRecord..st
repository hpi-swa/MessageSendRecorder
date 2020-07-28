accessing
topRecord: anObject

	topRecord := anObject.
	
	self changed: #label.
	self changed: #topRecords.

	self selectedRecord: (self topRecords ifEmpty: [nil] ifNotEmpty: [:records | records first]).