recording - post
fixTicks
	"Collect the ticks for nodes that have none."
	
	self topRecord extension ticks ifNil: [^ self].

	self topRecord doLast: [:record |
		record extension ticks ifNil: [
			record extension ticks: (
				record children
					inject: 0
					into: [:all :child | all + child extension ticks])]].