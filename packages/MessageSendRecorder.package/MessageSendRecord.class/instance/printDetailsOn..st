printing
printDetailsOn: s

	self extension isOuterContext == true
		ifTrue: [
			s nextPutAll: '[] in '.
			s nextPutAll: self method methodClass name]
		ifFalse: [
			s nextPutAll: self receiverClass name.
			self method methodClass = self receiverClass
				ifFalse: [s nextPut: $(; nextPutAll: self method methodClass name; nextPut: $)]].
				
	s nextPutAll: '>>'.
	s nextPutAll: self method selector asString.
