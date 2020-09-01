examples
example10
	"
	self example10.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.

	recorder setMessageSend: (MessageSend receiver: Project current world selector: #imageForm).
	
	recorder record: #duration.
	recorder collectTimeRatio.
	recorder collectTimeToRun.
	
	recorder topRecord browse.