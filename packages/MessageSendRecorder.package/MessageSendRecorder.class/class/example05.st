examples
example05
	"
	self example05.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	recorder setMessageSend: [
		[[ Morph new color: Color yellow ] value ] value].
	
	recorder record: #duration.
	
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.