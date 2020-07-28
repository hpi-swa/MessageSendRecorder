examples
example06
	"
	self example06.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ 20 timesRepeat: [Morph new color: Color random] ].
	
	recorder recordAllObjects.
	
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.