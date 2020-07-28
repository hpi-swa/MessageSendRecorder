examples
example07
	"
	self example07.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ 20 timesRepeat: [Morph new color: Color random] ].
	
	recorder record.
	
	recorder topRecord
		explore;
		browse.