app.factory 'Kanaboard', () ->
	board = [
		[
			type: "number"
			value: "0"
		,
			type: "number"
			value: "1"
		,
			type: "number"
			value: "2"
		,
			type: "number"
			value: "3"
		,
			type: "number"
			value: "4"
		,
			type: "number"
			value: "5"
		,
			type: "number"
			value: "6"
		,
			type: "number"
			value: "7"
		,
			type: "number"
			value: "8"
		,
			type: "number"
			value: "9"
		]
	,
		[
			type: "kana"
			value: "wa"
			hiragana:
				text: "わ"
			katakana:
				text: "ワ"
		,
			type: "kana"
			value: "ra"
			hiragana:
				text: "ら"
			katakana:
				text: "ラ"
		,
			type: "kana"
			value: "ya"
			hiragana:
				text: "や"
				chiisai: "ゃ"
			katakana:
				text: "ヤ"
				chiisai: "ャ"
		,
			type: "kana"
			value: "ma"
			hiragana:
				text: "ま"
			katakana:
				text: "マ"
		,
			type: "kana"
			value: "ha"
			hiragana:
				text: "は"
				tenten: "ば"
				maru: "ぱ"
			katakana:
				text: "ハ"
				tenten: "バ"
				maru: "パ"
		,
			type: "kana"
			value: "na"
			hiragana:
				text: "な"
			katakana:
				text: "ナ"
		,
			type: "kana"
			value: "ta"
			hiragana:
				text: "た"
				tenten: "だ"
			katakana:
				text: "タ"
				tenten: "ダ"
		,
			type: "kana"
			value: "sa"
			hiragana:
				text: "さ"
				tenten: "ざ"
			katakana:
				text: "サ"
				tenten: "ザ"
		,
			type: "kana"
			value: "ka"
			hiragana:
				text: "か"
				tenten: "が"
			katakana:
				text: "カ"
				tenten: "ガ"
		,
			type: "kana"
			value: "a"
			hiragana:
				text: "あ"
				chiisai: "ぁ"
			katakana:
				text: "ア"
				chiisai: "ァ"
		]
	,
		[
			type: "kana"
			value: "wo"
			hiragana:
				text: "を"
			katakana:
				text: "ヲ"
		,
			type: "kana"
			value: "ri"
			hiragana:
				text: "り"
			katakana:
				text: "リ"
		,
			type: "kana"
			value: "yu"
			hiragana:
				text: "ゆ"
				chiisai: "ゅ"
			katakana:
				text: "ユ"
				chiisai: "ュ"
		,
			type: "kana"
			value: "mi"
			hiragana:
				text: "み"
			katakana:
				text: "ミ"
		,
			type: "kana"
			value: "hi"
			hiragana:
				text: "ひ"
				tenten: "び"
				maru: "ぴ"
			katakana:
				text: "ヒ"
				tenten: "ビ"
				maru: "ピ"
		,
			type: "kana"
			value: "ni"
			hiragana:
				text: "に"
			katakana:
				text: "ニ"
		,
			type: "kana"
			value: "chi"
			hiragana:
				text: "ち"
				tenten: "ぢ"
			katakana:
				text: "チ"
				tenten: "ヂ"
		,
			type: "kana"
			value: "shi"
			hiragana:
				text: "し"
				tenten: "じ"
			katakana:
				text: "シ"
				tenten: "ジ"
		,
			type: "kana"
			value: "ki"
			hiragana:
				text: "き"
				tenten: "ぎ"
			katakana:
				text: "キ"
				tenten: "ギ"
		,
			type: "kana"
			value: "i"
			hiragana:
				text: "い"
				chiisai: "ぃ"
			katakana:
				text: "イ"
				chiisai: "ィ"

		]
	,
		[
			type: "kana"
			value: "n"
			hiragana:
				text: "ん"
			katakana:
				text: "ン"
		,
			type: "kana"
			value: "ru"
			hiragana:
				text: "る"
			katakana:
				text: "ル"
		,
			type: "kana"
			value: "yo"
			hiragana:
				text: "よ"
				chiisai: "ょ"
			katakana:
				text: "ヨ"
				chiisai: "ョ"
		,
			type: "kana"
			value: "mu"
			hiragana:
				text: "む"
			katakana:
				text: "ム"
		,
			type: "kana"
			value: "hu"
			hiragana:
				text: "ふ"
				tenten: "ぶ"
				maru: "ぷ"
			katakana:
				text: "フ"
				tenten: "ブ"
				maru: "プ"
		,
			type: "kana"
			value: "nu"
			hiragana:
				text: "ぬ"
			katakana:
				text: "ヌ"
		,
			type: "kana"
			value: "tsu"
			hiragana:
				text: "つ"
				tenten: "づ"
				chiisai: "っ"
			katakana:
				text: "ツ"
				tenten: "ヅ"
				chiisai: "ッ"
		,
			type: "kana"
			value: "su"
			hiragana:
				text: "す"
				tenten: "ず"
			katakana:
				text: "ス"
				tenten: "ズ"
		,
			type: "kana"
			value: "ku"
			hiragana:
				text: "く"
				tenten: "ぐ"
			katakana:
				text: "ク"
				tenten: "グ"
		,
			type: "kana"
			value: "u"
			hiragana:
				text: "う"
				chiisai: "ぅ"
			katakana:
				text: "ウ"
				chiisai: "ゥ"
		]
		,
		[
			type: "ponctuation"
			value: "?"
			text: "?"
		,
			type: "kana"
			value: "re"
			hiragana:
				text: "れ"
			katakana:
				text: "レ"
		,
			type: "kana"
			value: ","
			text: "、"
		,
			type: "kana"
			value: "me"
			hiragana:
				text: "め"
			katakana:
				text: "メ"
		,
			type: "kana"
			value: "he"
			hiragana:
				text: "へ"
				tenten: "べ"
				maru: "ぺ"
			katakana:
				text: "ヘ"
				tenten: "ベ"
				maru: "ペ"
		,
			type: "kana"
			value: "ne"
			hiragana:
				text: "ね"
			katakana:
				text: "ネ"
		,
			type: "kana"
			value: "te"
			hiragana:
				text: "て"
				tenten: "で"
			katakana:
				text: "テ"
				tenten: "デ"
		,
			type: "kana"
			value: "se"
			hiragana:
				text: "せ"
				tenten: "ぜ"
			katakana:
				text: "セ"
				tenten: "ゼ"
		,
			type: "kana"
			value: "ke"
			hiragana:
				text: "け"
				tenten: "げ"
			katakana:
				text: "ケ"
				tenten: "ゲ"
		,
			type: "kana"
			value: "e"
			hiragana:
				text: "え"
				chiisai: "ぇ"
			katakana:
				text: "エ"
				chiisai: "ェ"
		]
		,
		[
			type: "ponctuation"
			value: "-"
			text: "ー"
		,
			type: "kana"
			value: "ro"
			hiragana:
				text: "ろ"
			katakana:
				text: "ロ"
		,
			type: "ponctuation"
			value: "."
			text: "。"
		,
			type: "kana"
			value: "mo"
			hiragana:
				text: "も"
			katakana:
				text: "モ"
		,
			type: "kana"
			value: "ho"
			hiragana:
				text: "ほ"
				tenten: "ぼ"
				maru: "ぽ"
			katakana:
				text: "ホ"
				tenten: "ボ"
				maru: "ポ"
		,
			type: "kana"
			value: "no"
			hiragana:
				text: "の"
			katakana:
				text: "ノ"
		,
			type: "kana"
			value: "to"
			hiragana:
				text: "と"
				tenten: "ど"
			katakana:
				text: "ト"
				tenten: "ド"
		,
			type: "kana"
			value: "so"
			hiragana:
				text: "そ"
				tenten: "ぞ"
			katakana:
				text: "ソ"
				tenten: "ゾ"
		,
			type: "kana"
			value: "ko"
			hiragana:
				text: "こ"
				tenten: "ご"
			katakana:
				text: "コ"
				tenten: "ゴ"
		,
			type: "kana"
			value: "o"
			hiragana:
				text: "お"
				chiisai: "ぉ"
			katakana:
				text: "オ"
				chiisai: "ォ"
		]
	]
	return {
		getCellByValue: (value) ->
			for row in board
				for cell in row
					if cell.value is value then return cell
			return null
		get: () ->
			return board
	}
