app.controller "MainCtrl", ($scope, UserSettings, $state, $location, $ionicSideMenuDelegate) ->
	console.log "MainCtrl: start the app!"

	#data shared by several controller
	$scope.data =
		kanas: ""
		freetext:
			text: ""
			language: "ja"


	$scope.$on "setKanas", (event, data) ->
		console.log "setKanas event", event, data
		return	if event.targetScope is $scope
		$scope.$broadcast event.name, data
		$state.go "tab.kanas"

		return

	$scope.$on "setFreetext", (event, data) ->
		console.log "setFreetext event", event, data
		return	if event.targetScope is $scope
		$scope.$broadcast event.name, data
		$state.go "tab.freetext"
		return

	$scope.$on "talk", (event, data) ->
		return	if event.targetScope is $scope
		$scope.$broadcast event.name, data
		return

	$scope.$on "$stateChangeStart", (event, toState, toParams, fromState, fromParams) ->
		console.log "Change state", toParams
		#if $ionicSideMenuDelegate.isOpen() is true
			#$ionicSideMenuDelegate.toggleLeft()
		return

	$scope.toggleMenu = ->
		$ionicSideMenuDelegate.toggleLeft()

	return
