app.factory "History", ['HistoryDataLocalStorage', (HistoryData) ->

	console.log "Read localStorage history..."
	history = HistoryData.get()
	console.log history.length, 'entries.'
	save = ->
		HistoryData.set history
	sortByDay = ->
		sorted = []
		count = 0
		if history.length is 0
			return {
				count: count
				days: sorted
			}
		day = {}
		previousKey = ""
		history.forEach (entry, index) ->
			entry.index = index
			count++
			d = new Date(entry.date)
			key = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate()
			unless previousKey is key
				sorted.push day	if day.date
				day =
					date: new Date(d.getFullYear(), d.getMonth(), d.getDate())
					entries: [entry]
			else
				day.entries.push entry
			previousKey = key
			return

		sorted.push day
		return {
			count: count
			days: sorted
		}

	api =
		get: ->
			sortByDay()

		add: (kanas) ->
			lastKanas = ""
			lastKanas = history[history.length - 1].kanas	if history.length > 0
			if lastKanas is kanas

				#increment the counter
				history[history.length - 1].counter++
			else

				#add a new entry
				entry =
					date: new Date()
					kanas: kanas
					counter: 1

				history.push entry
			save()
			return

		addFreeText: (text, language) ->
			lastEntry = {}
			lastEntry = history[history.length - 1]	if history.length > 0
			if lastEntry and lastEntry.text is text
				console.log "increment history counter"
				#increment the counter
				lastEntry.counter++
			else
				entry =
					type: "freetext"
					date: new Date()
					text: text
					language: language
					counter: 1

				history.push entry
			save()
			return

		removeEntry: (entry) ->
			history.splice entry.index, 1
			save()
			return
 api
]

app.factory 'HistoryDataLocalStorage', () ->
	STORAGE_ID = "kana-history"
	api =
		get: ->
			JSON.parse(localStorage.getItem(STORAGE_ID) or "[]")
		set: (history) ->
			localStorage.setItem STORAGE_ID, JSON.stringify(history)
	api


app.factory 'HistoryDataMockup', ->
	#Add an entry evey 6 hours
	history = []
	d = new Date()
	t = d.getTime()

	history.push
		date: new Date(2014,11,25,10,0)
		kanas: 'ぺんをたべたい'
		index: 0
	history.push
		date: new Date(2014,11,23,10,0)
		kanas: 'こうえんにいきたい'
		index: 1
	history.push
		date: new Date(2014,11,5,10,0)
		kanas: 'みずをください'
		index: 2
	history.push
		date: new Date(2014,10,5,10,0)
		kanas: 'いつまで？'
		index: 2
	if false
		for i in [0..999]
			history.push
				date: d.setTime(t - 1000 * 3600 * 6 * i)
				kanas: 'test' + i
				index: i
	api =
		get: ->
			history.reverse()
		set: ->
			console.info 'Do nothing'
	api
