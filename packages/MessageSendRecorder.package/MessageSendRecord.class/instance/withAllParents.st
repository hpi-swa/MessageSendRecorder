enumerating
withAllParents

	^ Array streamContents: [:s |
			self withAllParentsDo: [:record | s nextPut: record]]