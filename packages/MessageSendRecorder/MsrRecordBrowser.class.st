"
I can browse a tree of messande-send records. I look-and-feel like a debugger. Yet, I show information from the past.
"
Class {
	#name : #MsrRecordBrowser,
	#superclass : #CodeHolder,
	#instVars : [
		'topRecord',
		'selectedRecord',
		'selectedRecordPath',
		'receiverInspector',
		'contextInspector',
		'showStack'
	],
	#category : #'MessageSendRecorder-Tools'
}

{ #category : #'instance creation' }
MsrRecordBrowser class >> on: record [

	^ self new
		topRecord: record;
		yourself
]

{ #category : #'instance creation' }
MsrRecordBrowser class >> openOn: record [

	^ ToolBuilder open: (self on: record)
]

{ #category : #'code holder' }
MsrRecordBrowser >> aboutToStyle: aStyler [

	aStyler classOrMetaClass: self selectedClassOrMetaClass.
	^ true
]

{ #category : #'code holder - bindings' }
MsrRecordBrowser >> argumentNamed: name [
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

]

{ #category : #'code holder - bindings' }
MsrRecordBrowser >> bindingOf: aString [

	(self isArgument: aString)
		ifTrue: [^ aString -> (self argumentNamed: aString)].
		
	^ nil
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> browseSelection [

	self selectedRecord method browse.
]

{ #category : #building }
MsrRecordBrowser >> buildCodePaneWith: builder [
	
	| textSpec top controlButtons browseButtons annoSpec |
	top := builder pluggablePanelSpec new.
	top children: OrderedCollection new.
	
	controlButtons := self buildControlButtonsWith: builder.
	controlButtons frame: self controlButtonsFrame.
	top children add: controlButtons.
	
	self wantsOptionalButtons ifTrue: [
		browseButtons := self buildOptionalButtonsWith: builder.
		browseButtons frame: self optionalButtonsFrame.
		top children add: browseButtons].

	textSpec := builder pluggableCodePaneSpec new.
	textSpec 
		model: self;
		getText: #contents; 
		setText: #contents:notifying:; 
		selection: #contentsSelection; 
		menu: #codePaneMenu:shifted:;
		frame: self textFrame.
	top children add: textSpec.

	self wantsAnnotationPane ifTrue: [
		annoSpec := self buildAnnotationPaneWith: builder.
		annoSpec frame: self annotationFrame.
		top children add: annoSpec].
	.
	^ top
]

{ #category : #building }
MsrRecordBrowser >> buildControlButtonsWith: builder [
	"Inspired by Debugger"
	
	| panelSpec |
	panelSpec := builder pluggablePanelSpec new.
	panelSpec children: OrderedCollection new.
	self customButtonSpecs do:[:spec|
		| buttonSpec |
		buttonSpec := builder pluggableActionButtonSpec new.
		buttonSpec model: self.
		buttonSpec label: spec first.
		buttonSpec action: spec second.
		spec size > 2 ifTrue:
			[buttonSpec help: spec third.
			 spec size > 3 ifTrue:
				[buttonSpec enabled: spec fourth]].
		panelSpec children add: buttonSpec.
	].

	panelSpec layout: #horizontal. "buttons"
	^panelSpec
]

{ #category : #building }
MsrRecordBrowser >> buildWith: builder [

	| windowSpec treeSpec textSpec listSpec |
	windowSpec := builder pluggableWindowSpec new.
	windowSpec
		model: self;
		children: OrderedCollection new;
		label: #label;
		extent: self initialExtent.
	
	treeSpec := builder pluggableTreeSpec new.
	treeSpec
		model: self;
		roots: #topRecords;
		hasChildren: #hasChildren:;
		getChildren: #getChildren:;
		getSelected: #selectedRecord;
		setSelected: #selectedRecord:;
		getSelectedPath: #selectedRecordPath;
		menu: #treeMenu:;
		label: #getLabel:;
		icon: #getIcon:;
		help: #getHelp:;
		keyPress: #recordKey:from:;
		columns: {
			[:listMorph | (listMorph filteredItems collect: [:item |
				item preferredWidthOfColumn: 1]) max].
			[:listMorph | (listMorph filteredItems collect: [:item |
				item preferredWidthOfColumn: 2]) max].
			[:listMorph | (listMorph filteredItems collect: [:item |
				item preferredWidthOfColumn: 3]) max].
			nil.
			};
		autoDeselect: false;
		frame: (0@0 corner: 1@0.3).
	windowSpec children add: treeSpec.
	
	textSpec := self buildCodePaneWith: builder.
	textSpec frame: (0@0.3 corner: 1@0.8).
	windowSpec children add: textSpec.
	
	listSpec := receiverInspector buildFieldListWith: builder.
	listSpec 
		frame: (0@0.8 corner: 0.2@1);
		help: 'Current\receiver\fields' withCRs.
	windowSpec children add: listSpec.

	textSpec := receiverInspector buildValuePaneWith: builder.
	textSpec 
		help: '<- Select field' translated;
		frame: (0.2@0.8 corner: 0.5@1).
	windowSpec children add: textSpec.

	listSpec := contextInspector buildFieldListWith: builder.
	listSpec 
		frame: (0.5@0.8 corner: 0.7@1);
		help: 'Record\context\fields' withCRs.
	windowSpec children add: listSpec.

	textSpec := contextInspector buildValuePaneWith: builder.
	textSpec 
		help: '<- Select field' translated;
		frame: (0.7@0.8 corner: 1@1).
	windowSpec children add: textSpec.
	
	^ builder build: windowSpec
]

{ #category : #debugger }
MsrRecordBrowser >> canStep [

	^ self showStack not
]

{ #category : #'code holder' }
MsrRecordBrowser >> contentsSelection [

	| selector tokens start stop bodyStart |
	self selectedRecord ifNil: [^ 1 to: 0].
	
	bodyStart := (contents asString findString: String cr) + 1.
	
	self selectedRecord extension isOuterContext == true
		ifFalse: [selector := self selectedRecord method selector]
		ifTrue: [selector := #value].
	
	selector last == $: ifFalse: [
		^ (0 to: selector size - 1) + (contents asString findString: selector startingAt: bodyStart)].
	
	tokens := selector findTokens: ':'.
	tokens := tokens collect: [:ea | ea, ':'].
	
	start := contents asString findString: tokens first startingAt: bodyStart.
	
	tokens size = 1
		ifTrue: [
			stop := start + tokens first size - 1]
		ifFalse: [
			stop := contents asString findString: tokens last startingAt: start + tokens first size.
			stop := stop + tokens last size - 1].
	
	^ start to: stop
]

{ #category : #building }
MsrRecordBrowser >> controlButtonsFrame [
	^LayoutFrame new
		leftFraction: 0 offset: 0;
		topFraction: 0 offset: 0;
		rightFraction: 1 offset: 0;
		bottomFraction: 0 offset: self buttonHeight
]

{ #category : #building }
MsrRecordBrowser >> customButtonSpecs [
	"Inspired by Debugger."
	
	^ #(
		('Go to'		goTo		'Jump to message send with id')
		('Into'		stepInto		'step into message sends'	canStep)
		('Over'		stepOver		'step over message sends'	canStep)
		('Through'	stepThrough	'step into block'	canStep)
		('Full stack'	spawnSelectionStack	'spawn browser in stack mode')
		('Where'		showWhere		'select current message send')
		('Spawn'		spawnSelection	'spawn browser from here')
	)
]

{ #category : #'code holder - bindings' }
MsrRecordBrowser >> doItContext [

	^ self selectedRecordParent getContext
]

{ #category : #'code holder - bindings' }
MsrRecordBrowser >> doItReceiver [

	^ self selectedRecordParent getReceiver
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> expandPathTimeRatio [
	"Show path with high time ratio."
	
	| record max |
	self topRecord extension timeRatio ifNil: [^ self].
	
	record := self selectedRecord.
	max := 1.
		
	[max >= 0.001 and: [record children notEmpty]] whileTrue: [
		| ratios |
		ratios := record children collect: [:ea | ea extension timeRatio].
		max := ratios max.
		record := record children at: (ratios indexOf: max)].

	max >= 0.001
		ifTrue: [self selectRecord: record]
		ifFalse: [self selectRecord: record parent].
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> exploreSelection [

	ToolSet explore: self selectedRecord.
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> exploreSelectionReturnObject [

	ToolSet explore: self returnValue.
]

{ #category : #tree }
MsrRecordBrowser >> getChildren: record [

	^ record children
]

{ #category : #tree }
MsrRecordBrowser >> getHelp: record [

	^ String streamContents: [:s |
		record printDetailsOn: s.
		s cr.
		record printTempsAndValuesOn: s]
]

{ #category : #tree }
MsrRecordBrowser >> getIcon: record [

	^ Preferences visualExplorer
		ifTrue: [([record getReceiver iconOrThumbnailOfSize: 12] on: Error do: [nil])
			ifNil: [ToolIcons iconNamed: record receiverClass theNonMetaClass toolIcon]]
		ifFalse: [nil]

]

{ #category : #tree }
MsrRecordBrowser >> getLabel: record [

	^ String streamContents: [:s |	
		record printDetailsOn: s.
		
		s tab; space; nextPut: $#; print: record id; space; space.
		
		record extension timeToRun ifNotNil: [:ms |
			s tab.
			s nextPutAll: ms asString].		
		
		record extension timeRatio ifNotNil: [:ratio |
			s tab.
			ratio < 0.001 ifFalse: [
				ratio * 100 printOn: s showingDecimalPlaces: 1.
				s nextPut: $%]]].
]

{ #category : #debugger }
MsrRecordBrowser >> goTo [

	^ self selectRecordById
]

{ #category : #tree }
MsrRecordBrowser >> hasChildren: record [

	^ record children notEmpty
]

{ #category : #initialization }
MsrRecordBrowser >> initialize [

	super initialize.
	
	receiverInspector := Inspector on: nil.
	contextInspector := MsrRecordContextInspector on: nil.
	
	showStack := false.
]

{ #category : #'code holder - bindings' }
MsrRecordBrowser >> isArgument: name [

	^ self selectedRecordParent getArgumentNames includes: name
]

{ #category : #accessing }
MsrRecordBrowser >> label [

	^ (self topRecord isTopRecord
		and: [self topRecord parent receiver isBlock])			
			ifTrue: [self topRecord parent receiver decompile decompileString withoutLineEndings]
			ifFalse: [self getLabel: self topRecord]
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> mainTreeMenu: aMenu [ 
	<treeMenu>
	
	aMenu addList: #(
		('step into (e)'			stepInto)
		('step over (t)'			stepOver)
		('step through (T)'	stepThrough)
		-
		('go to... (p)'			goTo)
		('spawn (r)'			spawnSelection)
		('spawn stack (f)'	spawnSelectionStack)
		-
		('expand high ratio'	expandPathTimeRatio)
		-
		('record time to run' recordTimeToRun)
		('record all objects'	recordAllObjects	'Collect references of receiver, arguments, and return value.')
		('record all copies'	recordAllCopies	'Collect copies of receiver, arguments, and return value.')
		-
		('browse source (b)'		browseSelection)
		-
		('explore record'		exploreSelection)
		('explore return value' exploreSelectionReturnObject)
	).
			
	^ aMenu
]

{ #category : #building }
MsrRecordBrowser >> optionalButtonsFrame [
	^LayoutFrame new
		leftFraction: 0 offset: 0;
		topFraction: 0 offset: self buttonHeight;
		rightFraction: 1 offset: 0;
		bottomFraction: 0 offset: self buttonHeight*2
]

{ #category : #'tree - record' }
MsrRecordBrowser >> recordAllCopies [

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args |
			record extension
				receiverCopy: rcvr copy;
				argumentCopies: (args collect: [:ea | ea copy]).]}
		after: {[:record :rcvr :args :result |
			record extension
				returnCopy: result copy]}.

	self selectedRecordChanged.
]

{ #category : #'tree - record' }
MsrRecordBrowser >> recordAllObjects [

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args |
			record extension
				receiverObject: rcvr;
				argumentObjects: args.]}
		after: {[:record :rcvr :args :result |
			record extension
				returnObject: result]}.

	self selectedRecordChanged.
]

{ #category : #tree }
MsrRecordBrowser >> recordKey: key from: view [

	key == $p ifTrue: [^ self goTo].

	key == $e ifTrue: [^ self stepInto].
	key == $t ifTrue: [^ self stepOver].
	key == $T ifTrue: [^ self stepThrough].
	
	key == $f ifTrue: [^ self spawnSelectionStack].
	key == $w ifTrue: [^ self showWhere].
	
	key == $r ifTrue: [^ self spawnSelection].
	
	key == $b ifTrue: [^ self browseSelection].
	self messageListKey: key from: view.

]

{ #category : #'tree - record' }
MsrRecordBrowser >> recordTimeToRun [

	| stopwatch |
	stopwatch := Stopwatch new.

	self selectedRecord recorder
		recordInto: self selectedRecord
		before: {[:record :rcvr :args |
			stopwatch activate]}
		after: {[:record :rcvr :args :result |
			stopwatch suspend.
			record extension timeToRun: stopwatch duration asMilliSeconds.
			stopwatch reset]}.

	self selectedRecordChanged.
]

{ #category : #'code holder - bindings' }
MsrRecordBrowser >> returnValue [

	^ self selectedRecord getReturnValue
]

{ #category : #debugger }
MsrRecordBrowser >> selectRecord: aRecord [

	| path |
	path := aRecord withAllParents reversed.
	path := path allButFirst: (path indexOf: self topRecord).
	path
		ifEmpty: [self selectedRecord: self topRecords first]
		ifNotEmpty: [self selectedRecordPath: path].
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> selectRecordById [

	(Project uiManager request: 'Enter record id:')
		ifNotEmpty: [:token | self selectRecordById: token asInteger].
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> selectRecordById: id [

	self topRecord do: [:record |
		record id = id ifTrue: [^ self selectRecord: record]].
	
	"Spawn new browser to look for that id."
	(self spawn: self topRecord withAllParents last) model
		selectRecordById: id.
]

{ #category : #'code holder' }
MsrRecordBrowser >> selectedClass [

	^ self selectedRecordParent ifNotNil: [:r | r method methodClass]
]

{ #category : #'code holder' }
MsrRecordBrowser >> selectedClassOrMetaClass [

	^ self selectedClass
]

{ #category : #'code holder' }
MsrRecordBrowser >> selectedMessage [

	| record |
	(record := self selectedRecordParent) ifNil: [^ contents := ''].
	record isTopRecord ifTrue: [
		record parent receiver isBlock
			ifTrue: [^ contents := 'DoIt\\	' withCRs, record parent receiver decompile decompileString, ' value']
			ifFalse: [^ contents := ('SendIt\\	| args |\	self perform: #{1} withArguments: args.' withCRs format: {record parent selector})]].

	^ contents := record method getSource
]

{ #category : #'code holder' }
MsrRecordBrowser >> selectedMessageCategoryName [

	^self selectedClass organization categoryOfElement: self selectedMessageName
]

{ #category : #'code holder' }
MsrRecordBrowser >> selectedMessageName [

	^ self selectedRecordParent ifNotNil: [:r | r method selector]
]

{ #category : #'code holder' }
MsrRecordBrowser >> selectedMethod [

	| record |
	(record := self selectedRecordParent) ifNil: [^ nil].
	record isTopRecord ifTrue: [^ nil].
	^ record method
]

{ #category : #accessing }
MsrRecordBrowser >> selectedRecord [

	^ selectedRecord
]

{ #category : #accessing }
MsrRecordBrowser >> selectedRecord: anObject [

	selectedRecord := anObject.
	
	self changed: #selectedRecord.
	self contentsChanged.
	
	receiverInspector object: (selectedRecord ifNotNil: [:r | r parent getReceiver]).
	contextInspector object: selectedRecord.
]

{ #category : #debugger }
MsrRecordBrowser >> selectedRecordChanged [

	self changed: #objectChanged with: self selectedRecord.
	contextInspector update.
]

{ #category : #accessing }
MsrRecordBrowser >> selectedRecordParent [

	^ self selectedRecord ifNotNil: [:record | record isTopRecord ifTrue: [record] ifFalse: [record parent]]
]

{ #category : #accessing }
MsrRecordBrowser >> selectedRecordPath [

	^ selectedRecordPath
]

{ #category : #accessing }
MsrRecordBrowser >> selectedRecordPath: aPath [

	selectedRecordPath := aPath.
	self changed: #selectedRecordPath.
]

{ #category : #accessing }
MsrRecordBrowser >> showStack [

	^ showStack
]

{ #category : #accessing }
MsrRecordBrowser >> showStack: aBoolean [

	showStack := aBoolean.

	self changed: #topRecords.
	self selectedRecord: self topRecords first.
]

{ #category : #debugger }
MsrRecordBrowser >> showWhere [

	self changed: #contentsSelection.
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> spawn: record [

	^ ToolBuilder open: ((self class on: record)
		showStack: false;
		yourself)
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> spawnSelection [

	^ self spawn: self selectedRecord.
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> spawnSelectionStack [

	^ self spawnStack: self selectedRecord
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> spawnStack: record [

	^ ToolBuilder open: ((self class on: record)
		showStack: true;
		yourself)
]

{ #category : #debugger }
MsrRecordBrowser >> stepInto [

	self selectedRecord children
		ifNotEmpty: [:children | self selectRecord: children first]
		ifEmpty: [self stepOver].
]

{ #category : #debugger }
MsrRecordBrowser >> stepOver [

	| record next |
	record := self selectedRecord.
		
	[record = self topRecord or: [(next := record getNextSibling) notNil]]
		whileFalse: [record := record parent].

	record = self topRecord
		ifTrue: [self selectRecord: self topRecords first]
		ifFalse: [self selectRecord: next].
]

{ #category : #debugger }
MsrRecordBrowser >> stepThrough [
	"Step over but backtrack if we can find a block activation."
	
	| record next |
	record := self selectedRecord.
	self stepOver.
	
	next := record parent
		detect: [:child | child method == record parent method and: [child id > record id]]
		ifNone: [^ self].
	next := next children first.
	
	self selectedRecord id > next id
		ifTrue: [self selectRecord: next].
]

{ #category : #building }
MsrRecordBrowser >> textFrame [
	
	^ super textFrame
		topOffset: (self wantsOptionalButtons ifTrue: [self buttonHeight * 2] ifFalse: [self buttonHeight]);
		yourself
]

{ #category : #accessing }
MsrRecordBrowser >> topRecord [

	^ topRecord
]

{ #category : #accessing }
MsrRecordBrowser >> topRecord: anObject [

	topRecord := anObject.
	
	self changed: #label.
	self changed: #topRecords.

	self selectedRecord: (self topRecords ifEmpty: [nil] ifNotEmpty: [:records | records first]).
]

{ #category : #tree }
MsrRecordBrowser >> topRecords [

	^ self showStack
		ifTrue: [self topRecord withAllParents allButLast]
		ifFalse: [self topRecord children]
]

{ #category : #'tree - menu' }
MsrRecordBrowser >> treeMenu: aMenu [ 

	^ self menu: aMenu for: #(treeMenu)
]

{ #category : #building }
MsrRecordBrowser >> wantsAnnotationPane [

	^ Debugger wantsAnnotationPane
]

{ #category : #building }
MsrRecordBrowser >> wantsCodeProvenanceButton [

	^ false
]

{ #category : #building }
MsrRecordBrowser >> wantsOptionalButtons [

	^ Preferences extraDebuggerButtons
]

{ #category : #building }
MsrRecordBrowser >> windowColorToUse [

	^ Debugger new windowColorToUse
]
