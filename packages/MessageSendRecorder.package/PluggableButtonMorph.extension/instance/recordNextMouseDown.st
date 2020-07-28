*MessageSendRecorder-Tools
recordNextMouseDown

	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setRecordAllObjects.
	
	recorder record: #duration send: #mouseDown: to: self.