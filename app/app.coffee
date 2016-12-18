# Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
# for form inputs)

# org.apache.cordova.statusbar required

# It's very handy to add references to $state and $stateParams to the $rootScope
# so that you can access them from any scope within your applications.For example,
# <li ui-sref-active="active }"> will set the <li> // to active whenever
# 'contacts.list' or one of its decendents is active.
window.app = angular.module("app", [
	"ionic"
	"ct.ui.router.extras"
	"ngMoment"
	"angularUtils.directives.dirPagination"
]).run(($ionicPlatform) ->
	$ionicPlatform.ready ->
		console.log "Current platform", $ionicPlatform.device(), $ionicPlatform.platform()	if $ionicPlatform.device
		cordova.plugins.Keyboard.hideKeyboardAccessoryBar true	if window.cordova and window.cordova.plugins.Keyboard
		StatusBar.styleDefault()	if window.StatusBar
		return

	return
).run([
	"$rootScope"
	"$state"
	"$stateParams"
	($rootScope, $state, $stateParams) ->
		$rootScope.$state = $state
		$rootScope.$stateParams = $stateParams
]).run([
	"$moment"
	($moment) ->
		$moment.locale "ja"
]).config ($stateProvider, $urlRouterProvider) ->

	# Ionic uses AngularUI Router which uses the concept of states
	# Learn more here: https://github.com/angular-ui/ui-router
	# Set up the various states which the app can be in.
	# Each state's controller can be found in controllers.js

	# setup an abstract state for the tabs directive

	# Each tab has its own nav history stack:

	#params : ['kanas'],
	#unable to access the scope here ?

	$stateProvider.state("tab",
		url: "/tab"
		abstract: true
		templateUrl: "templates/tabs.html"
		deepStateRedirect: false
		sticky: false
	).state("tab.kanas",
		url: "/kanas"
		views:
			"tab-kanas":
				templateUrl: "templates/tab-kanas.html"
				controller: "KanasCtrl"

		deepStateRedirect: false
		sticky: false
	).state("tab.history",
		url: "/history"
		views:
			"tab-history":
				templateUrl: "templates/tab-history.html"
				controller: "HistoryCtrl as ctrl"

		deepStateRedirect: false
		sticky: true
	).state("tab.settings",
		url: "/settings"
		views:
			"tab-settings":
				templateUrl: "templates/tab-settings.html"
				controller: "SettingsCtrl"

		onExit: (UserSettings) ->
			console.log "exit data"
			return

		sticky: true
	).state "tab.freetext",
		url: "/freetext"
		views:
			"tab-freetext":
				templateUrl: "templates/tab-freetext.html"
				controller: "FreeTextCtrl as ctrl"

		sticky: true

	# if none of the above states are matched, use this as the fallback
	$urlRouterProvider.otherwise "/tab/kanas"
	return

