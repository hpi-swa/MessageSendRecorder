examples
example02
	"
	self example02.
	"	
	| recorder |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.
	"recorder setMessageSend: [ActiveWorld imageForm]."
	recorder setMessageSend: (MessageSend receiver: ActiveWorld selector: #imageForm).
	
	recorder
		record: #duration
		before: {[:record :rcvr :args |
			record extension
				argumentClasses: (args collect: [:ea | ea class])]}
		after: #().
	
	recorder collectTimeRatio.
	
	recorder topRecord explore; browse.