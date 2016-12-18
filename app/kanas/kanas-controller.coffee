app.controller "KanasCtrl", [
	"$scope"
	"Kanaboard"
	"Speech"
	"History"
	"UserSettings"
	"$stateParams"
	($scope, Kanaboard, Speech, History, UserSettings, $stateParams) ->
		$scope.board = Kanaboard.get()
		$scope.theme = UserSettings.get('theme')
		$scope.kanaVariation = 0
		$scope.lastCell = {}
		$scope.alphabet = "hiragana"

		console.log "KanaCtrl", $scope.data.kanas

		$scope.clickEvent = (cell) ->
			$scope.reset()
			cell.selected = true
			kana = $scope.getKana(cell)
			$scope.data.kanas = $scope.data.kanas + kana
			Speech.talk getPrononciation(cell)
			$scope.kanaVariation = 0
			$scope.lastCell = cell
			cell.status = "pushed"
			return

		getPrononciation = (cell) ->
			(if cell.value is "ha" then cell.katakana.text else $scope.getKana(cell))

		$scope.getKana = (cell) ->
			prop = (if $scope.alphabet is "hiragana" then "hiragana" else "katakana")
			return cell[prop].text	if cell[prop] and cell[prop].text
			cell.text or cell.value


		$scope.talk = ->
			#example from http://www.raymondcamden.com/2013/9/6/Working-with-Plugins-in-PhoneGap-30
			Speech.talk $scope.data.kanas, UserSettings.all()
			History.add $scope.data.kanas
			$scope.$emit "talk", $scope.data.kanas
			$scope.reset()
			return

		$scope.deleteAll = ->
			$scope.data.kanas = ""
			$scope.reset()
			return

		$scope.deleteLast = ->
			$scope.data.kanas = $scope.data.kanas.substr(0,$scope.data.kanas.length - 1)
			$scope.reset()
			return

		$scope.tenten = ->
			$scope.kanaVariation++
			kana = $scope.getKanaVariation($scope.lastCell)
			return	if kana is ""
			#replace the last kana
			$scope.data.kanas = $scope.data.kanas.substr(0, $scope.data.kanas.length - 1) + kana
			#$scope.$emit "change"
			return

		$scope.getKanaVariation = (cell) ->
			x = cell[$scope.alphabet]
			variations = [x.text]
			variations.push x.chiisai	if x.chiisai
			variations.push x.tenten	if x.tenten
			variations.push x.maru	if x.maru
			if $scope.kanaVariation < variations.length
				variations[$scope.kanaVariation]
			else
				$scope.kanaVariation = 0
				x.text

		$scope.switchAlphabet = ->
			if $scope.alphabet is "hiragana"
				$scope.alphabet = "katakana"
			else
				$scope.alphabet = "hiragana"
			return

		$scope.$on "setKanas", (event, data) ->
			console.log("on event setKanas")
			$scope.data.kanas = data.kanas
			#$scope.kanas = data.kanas.split("")
			return

		$scope.reset = ->
			for row in $scope.board
				for cell in row
					cell.selected = false

		return false

]
