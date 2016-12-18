app.controller "SettingsCtrl", [
	"$scope"
	"Speech"
	"UserSettings"
	"Kanaboard"
	"$state"
	($scope, Speech, UserSettings, Kanaboard, $state) ->
		console.log "SettingsCtrl start!"
		$scope.options =
			speed: UserSettings.get("speed")
			theme: UserSettings.get("theme")
		$scope.sample = "わたしはバスケットボールがだいすき。"

		$scope.themes = [
			value: "white"
			text: "White"
		,
			value: "purple"
			text: "Purple"
		,
			value: "orange"
			text: "Orange"
		,
			value: "rainbow"
			text: "Rainbow"
		]

		$scope.kanaSample = Kanaboard.get()[1]

		$scope.playSample = ->
			Speech.talk $scope.sample, $scope.options
			return

		$scope.save = ->
			UserSettings.save $scope.options
			return

		$scope.destroy = ->
			console.info "destroy!"
			return

		$scope.changeTheme = ->
			$state.go 'tab.kanas'

		$scope.$on "$stateChangeStart", (event, toState, toParams, fromState, fromParams) ->
			if fromState.name is 'tab.settings'
				console.log "Leaving the settings page, saving...", fromState, $scope.options
				UserSettings.save $scope.options
			return

]
