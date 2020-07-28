*MessageSendRecorder-Tools
recordNextKeyStroke

	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setRecordAllObjects.
	
	recorder record: #duration send: #keyStroke: to: self.