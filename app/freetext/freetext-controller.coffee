app.controller "FreeTextCtrl", [
	"$scope"
	"Speech"
	"History"
	($scope, Speech, History) ->
		@talk = ->
			#text and language are defined in the data propery of the global scope, attached to the MainController
			#scope inheritance is used to shared data between controllers.
			text = $scope.data.freetext.text
			language = $scope.data.freetext.language
			options = lang: language
			Speech.talk text, options
			History.addFreeText text, language
			$scope.$emit "talk"
			return

		@delete = ->
			$scope.data.freetext.text = ""

		$scope.$on "setFreetext", (event, data) =>
			console.log("on event setFreetext");
			@text = data.text
			@language = data.language
			return
		return false

]
