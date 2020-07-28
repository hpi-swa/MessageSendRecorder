code holder - bindings
argumentNamed: name
	"Needs #argumentClasses or #argumentObjects or #argumentCopies."
	
	| record argIndex |
	record := self selectedRecordParent.
	argIndex := record extension argumentNames indexOf: name.
	
	(record extension respondsTo: #argumentCopies) ifTrue: [
		record extension argumentCopies ifNotNil: [:objects |
			^ objects at: argIndex]].
	
	(record extension respondsTo: #argumentObjects) ifTrue: [
		record extension argumentObjects ifNotNil: [:objects |
			^ objects at: argIndex]].
	
	(record extension respondsTo: #argumentClasses) ifTrue: [
		record extension argumentClasses ifNotNil: [:objects |
			| argClass |
			argClass := objects at: argIndex.
			^ [argClass new] ifError: [argClass someInstance]]].

	^ nil
