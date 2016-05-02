# AdocJournal

A simple `Makefile` to create and maintain my `asciidoc` journal.

## Prerequisites

Install `asciidoc` and `make`.

## Setup

You can manually tweak anything, but your life will be easier if you set
these values in the `Makefile`:

    JOURNAL=foo
    AUTHOR=user <user@domain.com>

The `JOURNAL` value is the name of your journal.
The `AUTHOR` is the AsciiDoc author.

## Layout / How To Use

Assuming your `JOURNAL` is named `foo`:

1. Edit `foo.adoc` with static content. Links to things that are 
   imporant.
2. Edit `foo_journal.adoc` daily with your activities.
   1. The layout of a Journal entry is weekly H2 headers.
   2. Every day has a label.
   3. A day is comprised of, typically, only a bullet list.
3. Edit `notes/anything.adoc` with notes from any meeting you might be
   in or on a new project. You can always link the `notes/anything.adoc`
   file into the main `foo.adoc` file, include it in the `foo_journal.adoc`
   file, or even just link to it with `link:notes/anything.html[]`.
