examples
example08
	"
	self example08.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [ Morph new. 7 / 0 ].
	
	recorder record.
	
	recorder topRecord
		explore;
		browse.