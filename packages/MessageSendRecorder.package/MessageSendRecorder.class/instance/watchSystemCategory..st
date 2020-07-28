recording - methods
watchSystemCategory: aSystemCategory

	(SystemOrganization listAtCategoryNamed: aSystemCategory) do: [:className |
			self watchClass: (Smalltalk classNamed: className)].