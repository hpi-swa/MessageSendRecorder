A recorder for a single message send. Supports re-recording of specific information.

methods			... compiled methods to instrument for recording the message send
topRecord		... record that holds the initial message send in its #parent.
		
currentRecord	... when recording, this is the current one for adding children
nextRecordId	... when recording, this is the next identifying number for a new children