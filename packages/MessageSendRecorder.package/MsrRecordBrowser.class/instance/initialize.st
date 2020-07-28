initialization
initialize

	super initialize.
	
	receiverInspector := Inspector on: nil.
	contextInspector := MsrRecordContextInspector on: nil.
	
	showStack := false.