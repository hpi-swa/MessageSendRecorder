tree
recordKey: key from: view

	key == $p ifTrue: [^ self goTo].

	key == $e ifTrue: [^ self stepInto].
	key == $t ifTrue: [^ self stepOver].
	key == $T ifTrue: [^ self stepThrough].
	
	key == $f ifTrue: [^ self spawnSelectionStack].
	key == $w ifTrue: [^ self showWhere].
	
	key == $r ifTrue: [^ self spawnSelection].
	
	key == $b ifTrue: [^ self browseSelection].
	self messageListKey: key from: view.
