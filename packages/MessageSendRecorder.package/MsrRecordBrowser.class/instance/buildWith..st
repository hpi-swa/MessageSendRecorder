building
buildWith: builder

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