fields - streaming
streamInstanceVariablesOn: aStream
	"Just show the (named) temporary variables to the list. Hide internals. The receiver is in the debugger's companion inspector."

	self streamTemporaryVariablesOn: aStream.