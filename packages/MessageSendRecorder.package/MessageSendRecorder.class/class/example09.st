examples
example09
	"
	self example09.
	"	
	| recorder morph |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	
	morph := Morph new.
	recorder record: #duration send: #openInWorld to: morph.
	^ morph