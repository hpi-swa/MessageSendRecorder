examples
example04
	"
	self example04.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [self example04Text asMorph fullBounds].
	
	recorder recordAllObjects.
	
	recorder collectTimeRatio.
	recorder collectTimeToRun.
	
	recorder topRecord explore; browse.