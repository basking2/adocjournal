JOURNAL=foo
AUTHOR=user <user@domain.com>
DSTDIR=html
NOTES=$(shell find notes -name \*.adoc | sed -E 's/(.*)\.adoc/$(DSTDIR)\/\1\.html/')
.PHONY: init clean wall watch

all: $(DSTDIR)/$(JOURNAL).html $(DSTDIR)/$(JOURNAL)_journal.html $(NOTES)

clean:
	rm -fr "$(DSTDIR)"

html/$(JOURNAL).html: $(JOURNAL).adoc $(JOURNAL)_journal.adoc
	asciidoctor -D $(DSTDIR)/`dirname $(<)` $(<)

watch:
	if [[ -x "`which inotifywait`" ]]; then \
		while inotifywait -r -e modify,create,delete "`pwd`"; do \
			make all ; \
		done ;  \
	elif [[ -x "`which fswatch`" ]]; then \
		while fswatch -1 -r -x Created,Updated,Removed,Renamed,MovedTo "`pwd`"; do \
			make all ; \
		done ; \
	fi

$(DSTDIR)/%.html: %.adoc
	asciidoctor -D $(DSTDIR)/`dirname $(<)` $(<)

$(JOURNAL).adoc:
	make init

define JOURNAL_CSS
body {
    font-family: "Palatino", "Georgia", "Baskerville";
    padding: 0px;
    margin: 0px;
}

.halign-right {
    text-align: right;
}
.halign-left {
    text-align: left;
}
.halign-center {
    text-align: center;
}

.title {
    color: #7070f0;
    margin-top: 1em;
}

.quoteblock {
    margin-left: 2em;
    margin-right: 2em;
    font-style: italic;
}

.attribution {
    margin-left: 2em;
    margin-right: 2em;
    text-align: right;    
}

.line-through {
	text-decoration: line-through;
}

h1, h2, h3, h4, h5, h6 {
    font-family: "Gill Sans", "Helvetica", "Arial";
	font-weight: normal; /* lighter */
    color: #202070;
}

a {
    color: #0000f0;
    text-decoration: none;
}

.tableblock {
  margin: 0px;
}

a:hover {
    color: #7070f0;
    text-decoration: none;
}

ul {
    padding: 0em;
    padding-left: 1em;
    margin: 0em;
    margin-bottom: 0em;
}

ul p {
    padding: 0em;
    margin: 0em;
}

#header {
    text-align: center;
    font-family: "Gill Sans", "Helvetica", "Arial";
	font-weight: lighter;
}

#header span.email:after {
    content: '\A';
    white-space: pre;
}

#header .details br {
    display: none;
}

#header h1 {
    left: 15em;
    right: 15em;
}

#header .details {
    margin-left: 15em;
    margin-right: 15em;
}

#toc a {
    color: #505050;
}

#toc {
    color: #505050;
    text-align: left;
    max-width: 15em;
    width: 15em;
    float: left;
    position: fixed;
    background: #f0f0f0;
    bottom: 0;
    top: 0;
    overflow-y: scroll;
}

#toctitle {
    margin-top: 2em;
	font-weight: normal;
}

/* Snagged this from https://css-tricks.com/snippets/css/make-pre-text-wrap/ */
#content pre {
    white-space: pre-wrap;       /* css-3 */
    white-space: -moz-pre-wrap;  /* Mozilla, since 1999 */
    white-space: -pre-wrap;      /* Opera 4-6 */
    white-space: -o-pre-wrap;    /* Opera 7 */
    word-wrap: break-word;       /* Internet Explorer 5.5+ */
}

#content {
    width: auto;
    margin-left: 20em;
}

#footer {
    background: #f0f0f0;
    padding: 2em;
    text-align: center;
    padding: 0px;
    margin: 0px;
    padding-top: 1em;
    padding-bottom: 1em;
}

endef

define JOURNAL_LOG
///////////////////////////////////
/// Journal
///////////////////////////////////

ifndef::included[]
= Journal
$(AUTHOR)
:toc: left
:toclevels: 6


== Introduction

A work journal.

endif::[]

== Feb 1 - 5, 2016

.February 1, 2016 - Monday
* An entry.

endef

define JOURNAL_TXT
= Main
$(AUTHOR)
:toc: left
:toclevels: 6
:stylesheet: $(JOURNAL).css
// :linkcss:

[[journal_start]]
== Journal

:included: true
:leveloffset: 1

include::$(JOURNAL)_journal.adoc[]

:leveloffset: 0
:included!:

[[journal_end]]



endef
export JOURNAL_TXT
export JOURNAL_CSS
export JOURNAL_LOG

init:
	echo Initializing journal space...
	echo "$$JOURNAL_CSS" > $(JOURNAL).css
	echo "$$JOURNAL_LOG" > $(JOURNAL)_journal.adoc
	echo "$$JOURNAL_TXT" > $(JOURNAL).adoc
	mkdir notes || true
