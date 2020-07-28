initialization
setRecord: aRecord

	self assert: [aRecord isTopRecord].

	recorder := aRecord recorder.
	receiver := aRecord parent receiver.