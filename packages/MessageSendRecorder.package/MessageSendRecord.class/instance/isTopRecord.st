testing
isTopRecord
	"I am the top record if my parent is the initial message send that produced this record tree."

	"^ self id = 0"
	^ self parent isMessageSend