REBOL [
  Title:   "Generates Red equal? tests"
	Author:  "Peter W A Wood"
	File: 	 %make-equal-auto-test.r
	Version: 0.1.0
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2012 Peter W A Wood. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

;; initialisations 

make-dir %auto-tests/
infix-file: %auto-tests/infix-equal-auto-test.red
prefix-file: %auto-tests/equal-auto-test.red

test-src: {
Red [
	Title:   "Red infix or prefix equal test script"
	Author:  "Nenad Rakocevic & Peter W A Wood"
	File: 	 ***FILE***
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2012, 2012 Nenad Rakocevic & Peter W A Wood. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

comment {  This file is generated by make-equal-auto-test.r
  Do not edit this file directly.
}

;make-length:***MAKELENGTH***           

;; counters
qt-run-tests: 0 
qt-run-asserts: 0
qt-run-passes: 0
qt-run-failures: 0
qt-file-tests: 0 
qt-file-asserts: 0 
qt-file-passes: 0 
qt-file-failures: 0

;; group switches
qt-group-name-not-printed: true
qt-group?: false

_qt-init-group: func [] [
  qt-group-name-not-printed: true
  qt-group?: false
  qt-group-name: ""
]

qt-init-run: func [] [
  qt-run-tests: 0 
  qt-run-asserts: 0
  qt-run-passes: 0
  qt-run-failures: 0
  _qt-init-group
]

qt-init-file: func [] [
  qt-file-tests: 0 
  qt-file-asserts: 0 
  qt-file-passes: 0 
  qt-file-failures: 0
  _qt-init-group
]

***start-run***: func[
    title [string!]
][
  qt-init-run
  qt-run-name: title
  prin "***Starting*** " 
  print title
]

~~~start-file~~~: func [
  title [string!]
][
  qt-init-file
  prin "~~~started test~~~ "
  print title
  qt-file-name: title
  qt-group?: false
]

===start-group===: func [
  title [string!]
][
  qt-group-name: title
  qt-group?: true
]

--test--: func [
  title [string!]
][
  qt-test-name: title
  qt-file-tests: qt-file-tests + 1
]

--assert: func [
  assertion [logic!]
][

  qt-file-asserts: qt-file-asserts + 1
  
  either assertion [
     qt-file-passes: qt-file-passes + 1
  ][
    qt-file-failures: qt-file-failures + 1
    if qt-group? [  
      if qt-group-name-not-printed [
        prin "===group=== "
        print qt-group-name
        qt-group-name-not-printed: false
      ]
    ]
    prin "--test-- " 
    prin qt-test-name
    print " FAILED**************"
  ]
]
 
===end-group===: func [] [
  _qt-init-group
]

qt-print-totals: func [
  tests     [integer!]
  asserts   [integer!]
  passes    [integer!]
  failures  [integer!]
][
  prin  "  Number of Tests Performed:      " 
  print tests 
  prin  "  Number of Assertions Performed: "
  print asserts
  prin  "  Number of Assertions Passed:    "
  print passes
  prin  "  Number of Assertions Failed:    "
  print failures
  if failures <> 0 [
    print "****************TEST FAILURES****************"
  ]
]

~~~end-file~~~: func [] [
  print ""
  prin "~~~finished test~~~ " 
  print qt-file-name
  qt-print-totals qt-file-tests qt-file-asserts qt-file-passes qt-file-failures
  print ""
  
  ;; update run totals
  qt-run-passes: qt-run-passes + qt-file-passes
  qt-run-asserts: qt-run-asserts + qt-file-asserts
  qt-run-failures: qt-run-failures + qt-file-failures
  qt-run-tests: qt-run-tests + qt-file-tests
]

***end-run***: func [][
  prin "***Finished*** "
  print qt-run-name
  qt-print-totals qt-run-tests
                  qt-run-asserts
                  qt-run-passes
                  qt-run-failures
]

}

;;functions

group-title: ""                         ;; title of current group
group-test-no: 0                        ;; number of current test in group

add-equal-test: func [
  expected [string!]
  actual   [string!]
][
  add-test
  append infix-src join {--assert } [expected " = " actual newline]
  append prefix-src join {--assert equal? } [expected " " actual newline]
]

add-not-equal-test: func [
  expected [string!]
  actual   [string!]
][
  add-test
  append infix-src join {--assert not } [expected " = " actual newline]
  append prefix-src join {--assert not equal? } [expected " " actual newline]
]

add-test: func [] [
  group-test-no: group-test-no + 1
  append infix-src join {--test-- "infix-equal-} 
    [group-title "-" group-test-no {"} newline]
  append prefix-src join {--test-- "prefix-equal-} 
    [group-title "-" group-test-no {"} newline]
]

add-test-with-code: func [
  code        [string!]
  assertion   [string!]
][
  add-test
  append infix-src join code newline
  append prefix-src join code newline
  append infix-src join {--assert } [assertion newline]
  append prefix-src join {--assert } [assertion newline]
]
  
add-test-text: func [
  text  [string!]
][
  append infix-src join replace copy text "***FIX***" "infix" newline
  append prefix-src join replace copy text "***FIX***" "prefix" newline
]


start-group: func [
  title [string!]
][
  group-title: title
  group-test-no: 0
  add-test-text join {===start-group=== "} [title {"}]
]
  

;; processing 
replace test-src {***MAKELENGTH***} length? read %make-equal-auto-test.r
infix-src: copy test-src
replace infix-src {***FILE***} :infix-file
prefix-src: copy test-src
replace prefix-src {***FILE***} :prefix-file

add-test-text {~~~start-file~~~ "***FIX***-equal"}

start-group "same-datatype"
add-equal-test "0" "0"
add-equal-test "1" "1"
add-equal-test "FFFFFFFFh" "-1"
add-equal-test "[]" "[]"
add-equal-test "[a]" "[a]"
add-equal-test "[A]" "[a]"
add-equal-test "['a]" "[a]"
add-equal-test "[a:]" "[a]"
add-equal-test "[:a]" "[a]"
add-equal-test "[abcde]" "[abcde]"
add-equal-test "[a b c d]" "[a b c d]"
add-equal-test "[b c d]" "next [a b c d]"
add-equal-test "[b c d]" "(next [a b c d])"
add-equal-test {"a"} {"a"}
add-equal-test {"a"} {"A"}
add-equal-test {"abcdeè"} {"abcdeè"}
add-equal-test {(next "abcdeè")} {next "abcdeè"}
add-equal-test {(first "abcdeè")} {first "abcdeè"}
add-equal-test {(last "abcdeè")} {last "abcdeè"}
add-equal-test {"abcde^^(2710)é^^(010000)"} {"abcde^^(2710)é^^(010000)"} 
;; need to escape the ^ as file is processed by REBOL
add-equal-test {[d]} {back tail [a b c d]}
add-equal-test {"2345"} {next "12345"}
add-equal-test {#"z"} {#"z"}
add-not-equal-test {#"z"} {#"Z"}
add-not-equal-test {#"e"} {#"è"}
add-equal-test {#"^^(010000)"} {#"^^(010000)"}
add-equal-test {true} {true}
add-equal-test {false} {false}
add-not-equal-test {false} {true}
add-not-equal-test {true} {false}
add-equal-test {none} {none}
add-equal-test {'a} {'a}
add-equal-test {'a} {'A}
add-equal-test {(first [a])} {first [a]}
add-equal-test {'a} {first [A]}
add-equal-test {'a} {first ['a]}
add-equal-test {'a} {first [:a]}
add-equal-test {'a} {first [a:]}
add-equal-test {(first [a:])} {first [a:]}
add-equal-test {(first [:a])} {first [:a]}
add-equal-test {[a b c d e]} {first [[a b c d e]]}
add-test-with-code {ea-result: 1 = 1} {ea-result = true}
add-test-with-code {ea-result: 1 = 0} {ea-result = false}
add-test-with-code {ea-result: equal? 1 1} {ea-result = true}
add-test-with-code {ea-result: equal? 1 0} {ea-result = false}
add-test-text {===end-group===}

start-group {implcit-cast}
add-equal-test {#"0"} {48}
add-equal-test {48} {#"0"}
add-equal-test {#"^^(2710)"} {10000}
add-equal-test {#"^^(010000)"} {65536}
add-test-with-code {ea-result: #"1" = 49} {ea-result = true}
add-test-with-code {ea-result: equal? #"^^(010000)" 10000} {ea-result = false}
add-test-text {===end-group===}

add-test-text {~~~end-file~~~}

write infix-file infix-src
write prefix-file prefix-src

print "Equal auto test files generated"

