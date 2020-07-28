examples
example01
	"
	self example01.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ActiveWorld imageForm].
	recorder record: #duration.
	
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.