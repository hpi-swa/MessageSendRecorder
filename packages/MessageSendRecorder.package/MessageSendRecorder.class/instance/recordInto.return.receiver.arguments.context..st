recording - callbacks
recordInto: returningRecord return: anReturnObject receiver: aReceiverObject arguments: someArgumentObjects context: aContext

	(recordingHelpers at: #after) do: [:block |
		block value: returningRecord value: aReceiverObject value: someArgumentObjects value: anReturnObject].