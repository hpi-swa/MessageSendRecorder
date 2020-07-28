dynamic fields
removeAllFields

	self instVarNames do: [:field | self removeField: field].
	self organization removeEmptyCategories.