recording
record

	| wrappers |
	isFirstRecording := self topRecord children isEmpty.
	recordingProcess := Processor activeProcess.
	
	(wrappers := self createWrappers, self createWrappersForRandom)
		do: [:wrapper | wrapper install].

	[[^ self sendMessage]
		ensure: [
			self reset.
			wrappers do: [:wrapper | wrapper uninstall].
			self collectArgumentNames.
			self fixDuration.
			self fixTicks]
		
	] on: MsrRecordNotFound do: [:ex |
		wrappers do: [:wrapper | wrapper uninstall].
		wrappers := #().
		self notify: ('Re-recording failed. Expected record id {1} not found during a message send for parent {2}.' format: {ex expectedChildId. ex parentRecord printDetails})
	] on: Error, Halt, Warning do: [:ex |
		wrappers do: [:wrapper | wrapper uninstall].
		wrappers := #().
		ex pass].	
	
	^ nil