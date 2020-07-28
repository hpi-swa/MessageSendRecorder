recording - wrappers
wrapperClass

	self recordingMode == #duration ifTrue: [^ MsrProfilingMethodWrapper].
	self recordingMode == #specificCall ifTrue: [^ MsrSpecificCallWrapper].

	^ MsrMethodWrapper