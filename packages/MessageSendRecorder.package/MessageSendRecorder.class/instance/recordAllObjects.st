public
recordAllObjects
	"Hold on to all object pointers for receivers, arguments, and return values."
	
	self setRecordAllObjects.
	^ self record: #duration