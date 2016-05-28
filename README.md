# Espeak NG Spellcheck tools

This project contains tools to check Espeak NG spelling changes for improvements and/or regressions.

Prepare file xx-words.txt with list of checked files. You can get list of words in your language from e.g. from [LibreOffice dictionary](https://cgit.freedesktop.org/libreoffice/dictionaries/tree/)

Note, that words should finish with dot at the end, to make sure spelling output is in separate line for each word. If necessary you can put phrases in the line.

Then run `espeak-ng-spellcheck.sh` and check output files:

## Spelling

* `spelling.tmp` shows how words are spelled
* `spelling-diff.tmp` shows differences from previous `espeak-ng` run

## Rule decisions

* `rule-results.tmp` trace of rule decisions for all words
* `winning-rule-lines.tmp` only winning lines filtered out from  `rule-results.tmp`
 
* `winning-lines.tmp` full unsorted list of line numbers of winning rules
* `winning-lines-count.tmp` count how many times each rule line has win for all words
* `unused-lines.tmp` list of lines, which have never used for spelling decisisons






