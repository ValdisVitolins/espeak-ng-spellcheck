# Espeak NG Spellcheck tools

This project contains tools to check Espeak NG spelling changes for improvements and/or regressions.

Prepare file xx-words.txt with list of checked files. You can get list of words in your language from e.g. from [LibreOffice dictionary](https://cgit.freedesktop.org/libreoffice/dictionaries/tree/)

Note, that words should finish with dot at the end, to make sure spelling output is in separate line for each word. If necessary you can put phrases in the line.

Then run `./espeak-ng-spellcheck.sh [lang]` and check output files:

Where `[lang]` is optional two letter language code (default is `lv`)

## Spelling

* `xx_spelling_YYYY-MM-DD_HH-mm.txt` shows how words are spelled
* `xx_spelling-diff.txt` shows differences from previous `espeak-ng` run

## Rule decisions

* `xx_rule-results.txt` trace of rule decisions for all words
* `xx_winning-rule-lines.txt` only winning lines filtered out from  `rule-results.txt`
 
* `xx_winning-lines.txt` full unsorted list of line numbers of winning rules
* `xx_winning-lines-count.txt` count how many times each rule line has win for all words
* `xx_unused-lines.txt` list of lines, which have never used (won) for spelling decisions

