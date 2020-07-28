recording - post
fixDuration
	"Collect the duration for nodes that have none."
	
	self topRecord extension duration ifNil: [^ self].

	self topRecord doLast: [:record |
		record extension duration ifNil: [
			record extension duration: (
				record children
					inject: Duration new
					into: [:all :child | all + child extension duration])]].