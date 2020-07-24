Class {
	#name : #BaselineOfMessageSendRecorder,
	#superclass : #BaselineOf,
	#category : #BaselineOfMessageSendRecorder
}

{ #category : #baseline }
BaselineOfMessageSendRecorder >> baseline: spec [
	<baseline>
	
	spec for: #common do: [
		spec baseline: 'MethodWrappers' with: [
			spec
				repository: 'github://hpi-swa/MethodWrappers:master/packages'].

		spec package: 'MessageSendRecorder' with: [
			spec requires: #(MethodWrappers)].
				
		spec
			group: 'default' with: #('MessageSendRecorder')].

]
