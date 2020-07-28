recording - methods
watchClass: aClass

	aClass theNonMetaClass methodsDo: [:method | self watchMethod: method].
	aClass theMetaClass methodsDo: [:method | self watchMethod: method].