examples
example11
	"
	self example11.
	"	
	| recorder colors |
	recorder := MessageSendRecorder new.
	recorder watchPackageNamed: #Morphic.
	recorder watchPackageNamed: #Graphics.

	recorder setMessageSend: (MessageSend receiver: Project current world selector: #imageForm).
	
	colors := OrderedCollection new: 2000.
	
	recorder
		record: #normal
		before: {[:record :rcvr :args :ctxt | rcvr isMorph ifTrue: [colors add: rcvr color]]}
		after: #().
		
	colors explore.