#Web Speech API Specification:
#https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html

app.factory("Speech", (ParseOptions) ->
	talk: (text, options) ->
		if SpeechSynthesisUtterance? and speechSynthesis?
			u = new SpeechSynthesisUtterance()
			u.lang = (options and options.lang) or "ja"
			u.rate = ParseOptions.getNumber(options, "speed", 1)
			#u.volume is defined in the API but it does not work.
			u.text = text
			console.log "Speech API call", u
			speechSynthesis.speak u
		else
			console.info "Talk simulation", text, options
		return
).factory("SpeechTest", (ParseOptions) ->
	talk: (text, options) ->
		console.info "Talk simulation", text, options
		return
).factory "ParseOptions", ->
	getNumber: (options, key, defaultValue) ->
		return parseFloat(options[key])	if options and options[key] and not isNaN(options[key])
		defaultValue
