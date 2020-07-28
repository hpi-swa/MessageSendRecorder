initialization
reset
	"Reset the recorder for another recording on the same message send. Can be used to record additional properties in multiple recordings IF the message send has deterministic side effects."

	self currentRecord: self topRecord.
	self nextRecordId: self topRecord id + 1.
	
	self recordingMode: #normal.