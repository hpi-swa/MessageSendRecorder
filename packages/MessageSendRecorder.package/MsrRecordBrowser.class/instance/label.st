building
label

	^ (self topRecord isTopRecord
		and: [self topRecord parent receiver isBlock])			
			ifTrue: [self topRecord parent receiver decompile decompileString withoutLineEndings]
			ifFalse: [self getLabel: self topRecord]