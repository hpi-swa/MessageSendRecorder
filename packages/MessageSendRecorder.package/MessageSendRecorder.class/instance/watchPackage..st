recording - methods
watchPackage: aPackageInfo

	aPackageInfo actualMethodsDo: [:method | self watchMethod: method].