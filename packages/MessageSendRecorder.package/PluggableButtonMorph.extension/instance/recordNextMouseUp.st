*MessageSendRecorder-Tools
recordNextMouseUp

	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setRecordAllObjects.
	
	recorder record: #duration send: #mouseUp: to: self.