# Espeak NG Spellcheck tools

This project contains tools to check Espeak NG spelling changes for improvements and/or regressions.

<a class="anchor" id="step1">1. Prepare file `xx-words.txt` with list of checked files[<sup>1</sup>](#1).

<a class="anchor" id="step2">2. Run `./espeak-ng-spellcheck.sh [lang]` where `[lang]` is optional two letter language code (default is `lv`)[<sup>2</sup>](#2):

## Spelling

* `xx_spelling_YYYY-MM-DD_HH-mm.txt` shows how words are spelled
* `xx_spelling-diff.txt` shows differences from previous `espeak-ng` run

## Rule decisions

* `xx_rule-results.txt` trace of rule decisions for all words
* `xx_winning-rule-lines.txt` only winning lines filtered out from  `rule-results.txt`
 
* `xx_winning-lines.txt` full unsorted list of line numbers of winning rules
* `xx_winning-lines-count.txt` count how many times each rule line has win for all words
* `xx_unused-lines.txt` list of lines, which have never used (won) for spelling decisions


<a class="anchor" id="step3">3. Make changes in `xx_list` or `xx_rules` file of `espeak-ng` project.
 
<a class="anchor" id="step4">4. Go to [step 2](#step2).
 
<a class="anchor" id="step5">5. Compare differences in produced log files and check for regressions.

<a class="anchor" id="step6">6. Continue with [step 3](#step3) etc.

----

<a class="anchor" id="1"></a>1. There are already prepared files for several languages. You can get list of words in your language from e.g. from [LibreOffice dictionary](https://cgit.freedesktop.org/libreoffice/dictionaries/tree/). Note, that words should finish with dot at the end, to make sure spelling output is in separate line for each word. If necessary you can put phrases in the line.

<a class="anchor" id="2"></a>2. Script assumes espeak-ng poroject is located in `~/code/espeak-ng/` folder. Change settings (or project location) if necessary.
