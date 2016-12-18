app.factory "UserSettings", ->
	STORAGE_ID = "user-settings"
	console.log "Load user settings..."
	settings = JSON.parse(localStorage.getItem(STORAGE_ID) or "[]")
	defaultSettings =
		speed: 1
		theme: 'white'
	save = ->
		localStorage.setItem STORAGE_ID, JSON.stringify(settings)
		return
	api =
		get: (key) ->
			throw new Error("Not a valid settings key:" + key)	unless defaultSettings[key]
			settings[key] or defaultSettings[key]

		all: ->
			settings

		save: (newSettings) ->
			settings = newSettings
			save()
			return
	return api
