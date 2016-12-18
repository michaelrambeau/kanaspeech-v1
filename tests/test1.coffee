describe "Kanas controller tests", ->
	beforeEach module("app")
	console.log "start the tests!", new Date()
	it "it should add the hiragana", inject ($controller, Kanaboard) ->

		scope =
			data:
				kanas: 'abc'
			$on: (eventName, data) ->
				console.log "$on", eventName, data
			$emit: (eventName, data) ->
				console.log "$emit", eventName, data

		ctrl = $controller "KanasCtrl",
			$scope: scope

		scope.clickEvent Kanaboard.getCellByValue "a"
		expect(scope.data.kanas).toBe "abcあ"

		scope.deleteLast()
		expect(scope.data.kanas).toBe "abc"

		scope.deleteAll()
		expect(scope.data.kanas).toBe ""

		return

	it "checking the tenten button", inject ($controller, Kanaboard, SpeechTest) ->
		scope =
			data:
				kanas: 'ま'
			$on: (eventName, data) ->
				console.log "$on", eventName, data
			$emit: (eventName, data) ->
				console.log "$emit", eventName, data
		ctrl = $controller "KanasCtrl",
			$scope: scope,
			Speech: SpeechTest
		cell = Kanaboard.getCellByValue "ha"
		scope.clickEvent cell
		scope.tenten()
		expect(scope.data.kanas).toBe "まば"

		scope.tenten()
		expect(scope.data.kanas).toBe "まぱ"

		scope.tenten()
		expect(scope.data.kanas).toBe "まは"

		scope.tenten()
		expect(scope.data.kanas).toBe "まば"

		scope.clickEvent Kanaboard.getCellByValue "ka"
		expect(scope.data.kanas).toBe "まばか"

		scope.switchAlphabet()
		scope.clickEvent Kanaboard.getCellByValue "ko"
		expect(scope.data.kanas).toBe "まばかコ"
		scope.tenten()
		expect(scope.data.kanas).toBe "まばかゴ"

		return

	it "Calling the 'talk' function should update the history", inject ($controller, Kanaboard, SpeechTest, History) ->
		kanas = 'ミカエル'
		scope =
			$on: (eventName, data) ->
				console.log "$on", eventName, data
			$emit: (eventName, data) ->
				console.log "$emit", eventName, data
			data:
				kanas: 'ミカエル'
		ctrl = $controller "KanasCtrl",
			$scope: scope,
			Speech: SpeechTest
		h = History.get()
		n0 = h.count
		console.log n0, 'entries in the history'
		scope.talk()
		h = History.get()
		console.log h.days[0]
		entries = h.days[-1..][0].entries
		dump entries
		entry = entries[-1..][0]
		console.log entry
		#expect(h.count).toBe n0 + 1
		expect(entry.kanas).toBe 'ミカエル'


