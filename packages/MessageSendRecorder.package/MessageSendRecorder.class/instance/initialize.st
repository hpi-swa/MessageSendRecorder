initialization
initialize

	super initialize.
	
	self topRecord: (MessageSendRecord new id: 0; recorder: self; yourself).
	self methods: IdentitySet new.
	self objectIds: IdentityDictionary new.
	
	recordingHelpers := IdentityDictionary new.
	recordingHelpers at: #before put: #().
	recordingHelpers at: #after put: #().
	
	self reset.