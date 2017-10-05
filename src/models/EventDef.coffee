
origEventDefClone = EventDef::clone
origEventDefToLegacy = EventDef::toLegacy
origApplyMiscProps = EventDef::applyMiscProps

# defineStandardProps won't work :(
EventDef::standardPropMap.resourceEditable = true # automatically transfer

###
NOTE: will always be populated by applyMiscProps
###
EventDef::resourceIds = null
EventDef::resourceEditable = null # `null` is unspecified state

###
resourceId should already be normalized
###
EventDef::hasResourceId = (resourceId) ->
	resourceId in @resourceIds

###
resourceId should already be normalized
###
EventDef::removeResourceId = (resourceId) ->
	removeExact(@resourceIds, resourceId)

###
resourceId should already be normalized
###
EventDef::addResourceId = (resourceId) ->
	if not @hasResourceId(resourceId)
		@resourceIds.push(resourceId)


EventDef::getResourceIds = ->
	if @resourceIds
		@resourceIds.slice() # clone
	else
		[]


EventDef::clone = ->
	def = origEventDefClone.apply(this, arguments)
	def.resourceIds = @getResourceIds()
	def


EventDef::toLegacy = ->
	obj = origEventDefToLegacy.apply(this, arguments)
	resourceIds = @getResourceIds()

	obj.resourceId =
		if resourceIds.length == 1
			resourceIds[0]
		else
			null

	obj.resourceIds =
		if resourceIds.length > 1
			resourceIds
		else
			null

	if @resourceEditable? # allows an unspecified state
		obj.resourceEditable = @resourceEditable

	obj


EventDef::applyMiscProps = (rawProps) ->
	rawProps = $.extend({}, rawProps) # clone, because of delete

	@resourceIds = Resource.extractIds(rawProps, @source.calendar)

	delete rawProps.resourceId
	delete rawProps.resourceIds

	origApplyMiscProps.apply(this, arguments)
