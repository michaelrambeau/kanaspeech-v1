app.controller "HistoryCtrl", ($scope, $state, History, $moment) ->
	console.log "HistoryCtrl", $scope.data.kanas

	init = ->
		history = History.get()
		$scope.history = history.days.slice().reverse()
		$scope.isHistoryEmpty = history.count is 0
		return

	@showDelete = false
	@entriesPerPage = 7

	$scope.viewEntry = (entry) ->
		return false	if @showDelete is true
		if entry.type is "freetext"
			$scope.data.freetext = entry
			$state.go "tab.freetext"
			if false then $scope.$emit "setFreetext",
				text: entry.text
				language: entry.language
		else
			$scope.data.kanas = entry.kanas
			$state.go "tab.kanas"
			if false then $scope.$emit "setKanas",
				kanas: entry.kanas
		return

	$scope.formatHistoryKey = (key) ->
		array = key.split("-")
		d = new Date(array[0], array[1], array[2])
		$moment(d).format "YYYY年 M月 Do日"

	$scope.getEntryText = (entry) ->
		if entry.type is "freetext"
			entry.text
		else
			entry.kanas

	$scope.removeEntry = (entry) ->
		console.log "delete!!!"
		History.removeEntry entry
		init()
		return

	$scope.$on "talk", (event, data) ->
		init()
		return

	init()
	return
