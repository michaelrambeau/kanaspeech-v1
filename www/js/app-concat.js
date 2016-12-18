(function() {
  window.app = angular.module("app", ["ionic", "ct.ui.router.extras", "ngMoment", "angularUtils.directives.dirPagination"]).run(function($ionicPlatform) {
    $ionicPlatform.ready(function() {
      if ($ionicPlatform.device) {
        console.log("Current platform", $ionicPlatform.device(), $ionicPlatform.platform());
      }
      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        StatusBar.styleDefault();
      }
    });
  }).run([
    "$rootScope", "$state", "$stateParams", function($rootScope, $state, $stateParams) {
      $rootScope.$state = $state;
      return $rootScope.$stateParams = $stateParams;
    }
  ]).run([
    "$moment", function($moment) {
      return $moment.locale("ja");
    }
  ]).config(function($stateProvider, $urlRouterProvider) {
    $stateProvider.state("tab", {
      url: "/tab",
      abstract: true,
      templateUrl: "templates/tabs.html",
      deepStateRedirect: false,
      sticky: false
    }).state("tab.kanas", {
      url: "/kanas",
      views: {
        "tab-kanas": {
          templateUrl: "templates/tab-kanas.html",
          controller: "KanasCtrl"
        }
      },
      deepStateRedirect: false,
      sticky: false
    }).state("tab.history", {
      url: "/history",
      views: {
        "tab-history": {
          templateUrl: "templates/tab-history.html",
          controller: "HistoryCtrl as ctrl"
        }
      },
      deepStateRedirect: false,
      sticky: true
    }).state("tab.settings", {
      url: "/settings",
      views: {
        "tab-settings": {
          templateUrl: "templates/tab-settings.html",
          controller: "SettingsCtrl"
        }
      },
      onExit: function(UserSettings) {
        console.log("exit data");
      },
      sticky: true
    }).state("tab.freetext", {
      url: "/freetext",
      views: {
        "tab-freetext": {
          templateUrl: "templates/tab-freetext.html",
          controller: "FreeTextCtrl as ctrl"
        }
      },
      sticky: true
    });
    $urlRouterProvider.otherwise("/tab/kanas");
  });

}).call(this);

(function() {
  app.factory("History", [
    'HistoryDataLocalStorage', function(HistoryData) {
      var api, history, save, sortByDay;
      console.log("Read localStorage history...");
      history = HistoryData.get();
      console.log(history.length, 'entries.');
      save = function() {
        return HistoryData.set(history);
      };
      sortByDay = function() {
        var count, day, previousKey, sorted;
        sorted = [];
        count = 0;
        if (history.length === 0) {
          return {
            count: count,
            days: sorted
          };
        }
        day = {};
        previousKey = "";
        history.forEach(function(entry, index) {
          var d, key;
          entry.index = index;
          count++;
          d = new Date(entry.date);
          key = d.getFullYear() + "-" + d.getMonth() + "-" + d.getDate();
          if (previousKey !== key) {
            if (day.date) {
              sorted.push(day);
            }
            day = {
              date: new Date(d.getFullYear(), d.getMonth(), d.getDate()),
              entries: [entry]
            };
          } else {
            day.entries.push(entry);
          }
          previousKey = key;
        });
        sorted.push(day);
        return {
          count: count,
          days: sorted
        };
      };
      api = {
        get: function() {
          return sortByDay();
        },
        add: function(kanas) {
          var entry, lastKanas;
          lastKanas = "";
          if (history.length > 0) {
            lastKanas = history[history.length - 1].kanas;
          }
          if (lastKanas === kanas) {
            history[history.length - 1].counter++;
          } else {
            entry = {
              date: new Date(),
              kanas: kanas,
              counter: 1
            };
            history.push(entry);
          }
          save();
        },
        addFreeText: function(text, language) {
          var entry, lastEntry;
          lastEntry = {};
          if (history.length > 0) {
            lastEntry = history[history.length - 1];
          }
          if (lastEntry && lastEntry.text === text) {
            console.log("increment history counter");
            lastEntry.counter++;
          } else {
            entry = {
              type: "freetext",
              date: new Date(),
              text: text,
              language: language,
              counter: 1
            };
            history.push(entry);
          }
          save();
        },
        removeEntry: function(entry) {
          history.splice(entry.index, 1);
          save();
        }
      };
      return api;
    }
  ]);

  app.factory('HistoryDataLocalStorage', function() {
    var STORAGE_ID, api;
    STORAGE_ID = "kana-history";
    api = {
      get: function() {
        return JSON.parse(localStorage.getItem(STORAGE_ID) || "[]");
      },
      set: function(history) {
        return localStorage.setItem(STORAGE_ID, JSON.stringify(history));
      }
    };
    return api;
  });

  app.factory('HistoryDataMockup', function() {
    var api, d, history, i, t, _i;
    history = [];
    d = new Date();
    t = d.getTime();
    history.push({
      date: new Date(2014, 11, 25, 10, 0),
      kanas: 'ぺんをたべたい',
      index: 0
    });
    history.push({
      date: new Date(2014, 11, 23, 10, 0),
      kanas: 'こうえんにいきたい',
      index: 1
    });
    history.push({
      date: new Date(2014, 11, 5, 10, 0),
      kanas: 'みずをください',
      index: 2
    });
    history.push({
      date: new Date(2014, 10, 5, 10, 0),
      kanas: 'いつまで？',
      index: 2
    });
    if (false) {
      for (i = _i = 0; _i <= 999; i = ++_i) {
        history.push({
          date: d.setTime(t - 1000 * 3600 * 6 * i),
          kanas: 'test' + i,
          index: i
        });
      }
    }
    api = {
      get: function() {
        return history.reverse();
      },
      set: function() {
        return console.info('Do nothing');
      }
    };
    return api;
  });

}).call(this);

(function() {
  app.factory("UserSettings", function() {
    var STORAGE_ID, api, defaultSettings, save, settings;
    STORAGE_ID = "user-settings";
    console.log("Load user settings...");
    settings = JSON.parse(localStorage.getItem(STORAGE_ID) || "[]");
    defaultSettings = {
      speed: 1,
      theme: 'white'
    };
    save = function() {
      localStorage.setItem(STORAGE_ID, JSON.stringify(settings));
    };
    api = {
      get: function(key) {
        if (!defaultSettings[key]) {
          throw new Error("Not a valid settings key:" + key);
        }
        return settings[key] || defaultSettings[key];
      },
      all: function() {
        return settings;
      },
      save: function(newSettings) {
        settings = newSettings;
        save();
      }
    };
    return api;
  });

}).call(this);

(function() {
  app.factory("Speech", function(ParseOptions) {
    return {
      talk: function(text, options) {
        var u;
        if ((typeof SpeechSynthesisUtterance !== "undefined" && SpeechSynthesisUtterance !== null) && (typeof speechSynthesis !== "undefined" && speechSynthesis !== null)) {
          u = new SpeechSynthesisUtterance();
          u.lang = (options && options.lang) || "ja";
          u.rate = ParseOptions.getNumber(options, "speed", 1);
          u.text = text;
          console.log("Speech API call", u);
          speechSynthesis.speak(u);
        } else {
          console.info("Talk simulation", text, options);
        }
      }
    };
  }).factory("SpeechTest", function(ParseOptions) {
    return {
      talk: function(text, options) {
        console.info("Talk simulation", text, options);
      }
    };
  }).factory("ParseOptions", function() {
    return {
      getNumber: function(options, key, defaultValue) {
        if (options && options[key] && !isNaN(options[key])) {
          return parseFloat(options[key]);
        }
        return defaultValue;
      }
    };
  });

}).call(this);

(function() {
  app.controller("MainCtrl", function($scope, UserSettings, $state, $location, $ionicSideMenuDelegate) {
    console.log("MainCtrl: start the app!");
    $scope.data = {
      kanas: "",
      freetext: {
        text: "",
        language: "ja"
      }
    };
    $scope.$on("setKanas", function(event, data) {
      console.log("setKanas event", event, data);
      if (event.targetScope === $scope) {
        return;
      }
      $scope.$broadcast(event.name, data);
      $state.go("tab.kanas");
    });
    $scope.$on("setFreetext", function(event, data) {
      console.log("setFreetext event", event, data);
      if (event.targetScope === $scope) {
        return;
      }
      $scope.$broadcast(event.name, data);
      $state.go("tab.freetext");
    });
    $scope.$on("talk", function(event, data) {
      if (event.targetScope === $scope) {
        return;
      }
      $scope.$broadcast(event.name, data);
    });
    $scope.$on("$stateChangeStart", function(event, toState, toParams, fromState, fromParams) {
      console.log("Change state", toParams);
    });
    $scope.toggleMenu = function() {
      return $ionicSideMenuDelegate.toggleLeft();
    };
  });

}).call(this);

(function() {
  app.controller("FreeTextCtrl", [
    "$scope", "Speech", "History", function($scope, Speech, History) {
      this.talk = function() {
        var language, options, text;
        text = $scope.data.freetext.text;
        language = $scope.data.freetext.language;
        options = {
          lang: language
        };
        Speech.talk(text, options);
        History.addFreeText(text, language);
        $scope.$emit("talk");
      };
      this["delete"] = function() {
        return $scope.data.freetext.text = "";
      };
      $scope.$on("setFreetext", (function(_this) {
        return function(event, data) {
          console.log("on event setFreetext");
          _this.text = data.text;
          _this.language = data.language;
        };
      })(this));
      return false;
    }
  ]);

}).call(this);

(function() {
  app.controller("HistoryCtrl", function($scope, $state, History, $moment) {
    var init;
    console.log("HistoryCtrl", $scope.data.kanas);
    init = function() {
      var history;
      history = History.get();
      $scope.history = history.days.slice().reverse();
      $scope.isHistoryEmpty = history.count === 0;
    };
    this.showDelete = false;
    this.entriesPerPage = 7;
    $scope.viewEntry = function(entry) {
      if (this.showDelete === true) {
        return false;
      }
      if (entry.type === "freetext") {
        $scope.data.freetext = entry;
        $state.go("tab.freetext");
        if (false) {
          $scope.$emit("setFreetext", {
            text: entry.text,
            language: entry.language
          });
        }
      } else {
        $scope.data.kanas = entry.kanas;
        $state.go("tab.kanas");
        if (false) {
          $scope.$emit("setKanas", {
            kanas: entry.kanas
          });
        }
      }
    };
    $scope.formatHistoryKey = function(key) {
      var array, d;
      array = key.split("-");
      d = new Date(array[0], array[1], array[2]);
      return $moment(d).format("YYYY年 M月 Do日");
    };
    $scope.getEntryText = function(entry) {
      if (entry.type === "freetext") {
        return entry.text;
      } else {
        return entry.kanas;
      }
    };
    $scope.removeEntry = function(entry) {
      console.log("delete!!!");
      History.removeEntry(entry);
      init();
    };
    $scope.$on("talk", function(event, data) {
      init();
    });
    init();
  });

}).call(this);

(function() {
  app.factory('Kanaboard', function() {
    var board;
    board = [
      [
        {
          type: "number",
          value: "0"
        }, {
          type: "number",
          value: "1"
        }, {
          type: "number",
          value: "2"
        }, {
          type: "number",
          value: "3"
        }, {
          type: "number",
          value: "4"
        }, {
          type: "number",
          value: "5"
        }, {
          type: "number",
          value: "6"
        }, {
          type: "number",
          value: "7"
        }, {
          type: "number",
          value: "8"
        }, {
          type: "number",
          value: "9"
        }
      ], [
        {
          type: "kana",
          value: "wa",
          hiragana: {
            text: "わ"
          },
          katakana: {
            text: "ワ"
          }
        }, {
          type: "kana",
          value: "ra",
          hiragana: {
            text: "ら"
          },
          katakana: {
            text: "ラ"
          }
        }, {
          type: "kana",
          value: "ya",
          hiragana: {
            text: "や",
            chiisai: "ゃ"
          },
          katakana: {
            text: "ヤ",
            chiisai: "ャ"
          }
        }, {
          type: "kana",
          value: "ma",
          hiragana: {
            text: "ま"
          },
          katakana: {
            text: "マ"
          }
        }, {
          type: "kana",
          value: "ha",
          hiragana: {
            text: "は",
            tenten: "ば",
            maru: "ぱ"
          },
          katakana: {
            text: "ハ",
            tenten: "バ",
            maru: "パ"
          }
        }, {
          type: "kana",
          value: "na",
          hiragana: {
            text: "な"
          },
          katakana: {
            text: "ナ"
          }
        }, {
          type: "kana",
          value: "ta",
          hiragana: {
            text: "た",
            tenten: "だ"
          },
          katakana: {
            text: "タ",
            tenten: "ダ"
          }
        }, {
          type: "kana",
          value: "sa",
          hiragana: {
            text: "さ",
            tenten: "ざ"
          },
          katakana: {
            text: "サ",
            tenten: "ザ"
          }
        }, {
          type: "kana",
          value: "ka",
          hiragana: {
            text: "か",
            tenten: "が"
          },
          katakana: {
            text: "カ",
            tenten: "ガ"
          }
        }, {
          type: "kana",
          value: "a",
          hiragana: {
            text: "あ",
            chiisai: "ぁ"
          },
          katakana: {
            text: "ア",
            chiisai: "ァ"
          }
        }
      ], [
        {
          type: "kana",
          value: "wo",
          hiragana: {
            text: "を"
          },
          katakana: {
            text: "ヲ"
          }
        }, {
          type: "kana",
          value: "ri",
          hiragana: {
            text: "り"
          },
          katakana: {
            text: "リ"
          }
        }, {
          type: "kana",
          value: "yu",
          hiragana: {
            text: "ゆ",
            chiisai: "ゅ"
          },
          katakana: {
            text: "ユ",
            chiisai: "ュ"
          }
        }, {
          type: "kana",
          value: "mi",
          hiragana: {
            text: "み"
          },
          katakana: {
            text: "ミ"
          }
        }, {
          type: "kana",
          value: "hi",
          hiragana: {
            text: "ひ",
            tenten: "び",
            maru: "ぴ"
          },
          katakana: {
            text: "ヒ",
            tenten: "ビ",
            maru: "ピ"
          }
        }, {
          type: "kana",
          value: "ni",
          hiragana: {
            text: "に"
          },
          katakana: {
            text: "ニ"
          }
        }, {
          type: "kana",
          value: "chi",
          hiragana: {
            text: "ち",
            tenten: "ぢ"
          },
          katakana: {
            text: "チ",
            tenten: "ヂ"
          }
        }, {
          type: "kana",
          value: "shi",
          hiragana: {
            text: "し",
            tenten: "じ"
          },
          katakana: {
            text: "シ",
            tenten: "ジ"
          }
        }, {
          type: "kana",
          value: "ki",
          hiragana: {
            text: "き",
            tenten: "ぎ"
          },
          katakana: {
            text: "キ",
            tenten: "ギ"
          }
        }, {
          type: "kana",
          value: "i",
          hiragana: {
            text: "い",
            chiisai: "ぃ"
          },
          katakana: {
            text: "イ",
            chiisai: "ィ"
          }
        }
      ], [
        {
          type: "kana",
          value: "n",
          hiragana: {
            text: "ん"
          },
          katakana: {
            text: "ン"
          }
        }, {
          type: "kana",
          value: "ru",
          hiragana: {
            text: "る"
          },
          katakana: {
            text: "ル"
          }
        }, {
          type: "kana",
          value: "yo",
          hiragana: {
            text: "よ",
            chiisai: "ょ"
          },
          katakana: {
            text: "ヨ",
            chiisai: "ョ"
          }
        }, {
          type: "kana",
          value: "mu",
          hiragana: {
            text: "む"
          },
          katakana: {
            text: "ム"
          }
        }, {
          type: "kana",
          value: "hu",
          hiragana: {
            text: "ふ",
            tenten: "ぶ",
            maru: "ぷ"
          },
          katakana: {
            text: "フ",
            tenten: "ブ",
            maru: "プ"
          }
        }, {
          type: "kana",
          value: "nu",
          hiragana: {
            text: "ぬ"
          },
          katakana: {
            text: "ヌ"
          }
        }, {
          type: "kana",
          value: "tsu",
          hiragana: {
            text: "つ",
            tenten: "づ",
            chiisai: "っ"
          },
          katakana: {
            text: "ツ",
            tenten: "ヅ",
            chiisai: "ッ"
          }
        }, {
          type: "kana",
          value: "su",
          hiragana: {
            text: "す",
            tenten: "ず"
          },
          katakana: {
            text: "ス",
            tenten: "ズ"
          }
        }, {
          type: "kana",
          value: "ku",
          hiragana: {
            text: "く",
            tenten: "ぐ"
          },
          katakana: {
            text: "ク",
            tenten: "グ"
          }
        }, {
          type: "kana",
          value: "u",
          hiragana: {
            text: "う",
            chiisai: "ぅ"
          },
          katakana: {
            text: "ウ",
            chiisai: "ゥ"
          }
        }
      ], [
        {
          type: "ponctuation",
          value: "?",
          text: "?"
        }, {
          type: "kana",
          value: "re",
          hiragana: {
            text: "れ"
          },
          katakana: {
            text: "レ"
          }
        }, {
          type: "kana",
          value: ",",
          text: "、"
        }, {
          type: "kana",
          value: "me",
          hiragana: {
            text: "め"
          },
          katakana: {
            text: "メ"
          }
        }, {
          type: "kana",
          value: "he",
          hiragana: {
            text: "へ",
            tenten: "べ",
            maru: "ぺ"
          },
          katakana: {
            text: "ヘ",
            tenten: "ベ",
            maru: "ペ"
          }
        }, {
          type: "kana",
          value: "ne",
          hiragana: {
            text: "ね"
          },
          katakana: {
            text: "ネ"
          }
        }, {
          type: "kana",
          value: "te",
          hiragana: {
            text: "て",
            tenten: "で"
          },
          katakana: {
            text: "テ",
            tenten: "デ"
          }
        }, {
          type: "kana",
          value: "se",
          hiragana: {
            text: "せ",
            tenten: "ぜ"
          },
          katakana: {
            text: "セ",
            tenten: "ゼ"
          }
        }, {
          type: "kana",
          value: "ke",
          hiragana: {
            text: "け",
            tenten: "げ"
          },
          katakana: {
            text: "ケ",
            tenten: "ゲ"
          }
        }, {
          type: "kana",
          value: "e",
          hiragana: {
            text: "え",
            chiisai: "ぇ"
          },
          katakana: {
            text: "エ",
            chiisai: "ェ"
          }
        }
      ], [
        {
          type: "ponctuation",
          value: "-",
          text: "ー"
        }, {
          type: "kana",
          value: "ro",
          hiragana: {
            text: "ろ"
          },
          katakana: {
            text: "ロ"
          }
        }, {
          type: "ponctuation",
          value: ".",
          text: "。"
        }, {
          type: "kana",
          value: "mo",
          hiragana: {
            text: "も"
          },
          katakana: {
            text: "モ"
          }
        }, {
          type: "kana",
          value: "ho",
          hiragana: {
            text: "ほ",
            tenten: "ぼ",
            maru: "ぽ"
          },
          katakana: {
            text: "ホ",
            tenten: "ボ",
            maru: "ポ"
          }
        }, {
          type: "kana",
          value: "no",
          hiragana: {
            text: "の"
          },
          katakana: {
            text: "ノ"
          }
        }, {
          type: "kana",
          value: "to",
          hiragana: {
            text: "と",
            tenten: "ど"
          },
          katakana: {
            text: "ト",
            tenten: "ド"
          }
        }, {
          type: "kana",
          value: "so",
          hiragana: {
            text: "そ",
            tenten: "ぞ"
          },
          katakana: {
            text: "ソ",
            tenten: "ゾ"
          }
        }, {
          type: "kana",
          value: "ko",
          hiragana: {
            text: "こ",
            tenten: "ご"
          },
          katakana: {
            text: "コ",
            tenten: "ゴ"
          }
        }, {
          type: "kana",
          value: "o",
          hiragana: {
            text: "お",
            chiisai: "ぉ"
          },
          katakana: {
            text: "オ",
            chiisai: "ォ"
          }
        }
      ]
    ];
    return {
      getCellByValue: function(value) {
        var cell, row, _i, _j, _len, _len1;
        for (_i = 0, _len = board.length; _i < _len; _i++) {
          row = board[_i];
          for (_j = 0, _len1 = row.length; _j < _len1; _j++) {
            cell = row[_j];
            if (cell.value === value) {
              return cell;
            }
          }
        }
        return null;
      },
      get: function() {
        return board;
      }
    };
  });

}).call(this);

(function() {
  app.controller("KanasCtrl", [
    "$scope", "Kanaboard", "Speech", "History", "UserSettings", "$stateParams", function($scope, Kanaboard, Speech, History, UserSettings, $stateParams) {
      var getPrononciation;
      $scope.board = Kanaboard.get();
      $scope.theme = UserSettings.get('theme');
      $scope.kanaVariation = 0;
      $scope.lastCell = {};
      $scope.alphabet = "hiragana";
      console.log("KanaCtrl", $scope.data.kanas);
      $scope.clickEvent = function(cell) {
        var kana;
        $scope.reset();
        cell.selected = true;
        kana = $scope.getKana(cell);
        $scope.data.kanas = $scope.data.kanas + kana;
        Speech.talk(getPrononciation(cell));
        $scope.kanaVariation = 0;
        $scope.lastCell = cell;
        cell.status = "pushed";
      };
      getPrononciation = function(cell) {
        if (cell.value === "ha") {
          return cell.katakana.text;
        } else {
          return $scope.getKana(cell);
        }
      };
      $scope.getKana = function(cell) {
        var prop;
        prop = ($scope.alphabet === "hiragana" ? "hiragana" : "katakana");
        if (cell[prop] && cell[prop].text) {
          return cell[prop].text;
        }
        return cell.text || cell.value;
      };
      $scope.talk = function() {
        Speech.talk($scope.data.kanas, UserSettings.all());
        History.add($scope.data.kanas);
        $scope.$emit("talk", $scope.data.kanas);
        $scope.reset();
      };
      $scope.deleteAll = function() {
        $scope.data.kanas = "";
        $scope.reset();
      };
      $scope.deleteLast = function() {
        $scope.data.kanas = $scope.data.kanas.substr(0, $scope.data.kanas.length - 1);
        $scope.reset();
      };
      $scope.tenten = function() {
        var kana;
        $scope.kanaVariation++;
        kana = $scope.getKanaVariation($scope.lastCell);
        if (kana === "") {
          return;
        }
        $scope.data.kanas = $scope.data.kanas.substr(0, $scope.data.kanas.length - 1) + kana;
      };
      $scope.getKanaVariation = function(cell) {
        var variations, x;
        x = cell[$scope.alphabet];
        variations = [x.text];
        if (x.chiisai) {
          variations.push(x.chiisai);
        }
        if (x.tenten) {
          variations.push(x.tenten);
        }
        if (x.maru) {
          variations.push(x.maru);
        }
        if ($scope.kanaVariation < variations.length) {
          return variations[$scope.kanaVariation];
        } else {
          $scope.kanaVariation = 0;
          return x.text;
        }
      };
      $scope.switchAlphabet = function() {
        if ($scope.alphabet === "hiragana") {
          $scope.alphabet = "katakana";
        } else {
          $scope.alphabet = "hiragana";
        }
      };
      $scope.$on("setKanas", function(event, data) {
        console.log("on event setKanas");
        $scope.data.kanas = data.kanas;
      });
      $scope.reset = function() {
        var cell, row, _i, _len, _ref, _results;
        _ref = $scope.board;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          row = _ref[_i];
          _results.push((function() {
            var _j, _len1, _results1;
            _results1 = [];
            for (_j = 0, _len1 = row.length; _j < _len1; _j++) {
              cell = row[_j];
              _results1.push(cell.selected = false);
            }
            return _results1;
          })());
        }
        return _results;
      };
      return false;
    }
  ]);

}).call(this);

(function() {
  app.controller("SettingsCtrl", [
    "$scope", "Speech", "UserSettings", "Kanaboard", "$state", function($scope, Speech, UserSettings, Kanaboard, $state) {
      console.log("SettingsCtrl start!");
      $scope.options = {
        speed: UserSettings.get("speed"),
        theme: UserSettings.get("theme")
      };
      $scope.sample = "わたしはバスケットボールがだいすき。";
      $scope.themes = [
        {
          value: "white",
          text: "White"
        }, {
          value: "purple",
          text: "Purple"
        }, {
          value: "orange",
          text: "Orange"
        }, {
          value: "rainbow",
          text: "Rainbow"
        }
      ];
      $scope.kanaSample = Kanaboard.get()[1];
      $scope.playSample = function() {
        Speech.talk($scope.sample, $scope.options);
      };
      $scope.save = function() {
        UserSettings.save($scope.options);
      };
      $scope.destroy = function() {
        console.info("destroy!");
      };
      $scope.changeTheme = function() {
        return $state.go('tab.kanas');
      };
      return $scope.$on("$stateChangeStart", function(event, toState, toParams, fromState, fromParams) {
        if (fromState.name === 'tab.settings') {
          console.log("Leaving the settings page, saving...", fromState, $scope.options);
          UserSettings.save($scope.options);
        }
      });
    }
  ]);

}).call(this);
