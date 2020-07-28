instance creation
on: record

	^ (self on: record selector inClass: record receiverClass)
		setRecord: record;
		yourself