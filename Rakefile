
require 'asciidoctor'
require 'asciidoctor-diagram'
require 'asciidoctor-pdf'

htmldir = 'html'
pdfdir = 'pdf'

JOURNAL='foo'
AUTHOR='user <user@domain.com>'

htmldocs = [ 
  [
    "#{JOURNAL}.adoc",
  ],
  Dir['notes/**/*.adoc'],
  Dir['projects/**/*.adoc'],
  Dir['scraps/**/*.adoc'],
].flatten.map do |src|

  original_dir = Rake.application.original_dir
  outdir = File.dirname(File.absolute_path(src)).sub(original_dir, htmldir)
  outdir = File.join(original_dir, outdir)
  tgt = File.join(outdir, File.basename(src).sub(/\.adoc$/, '.html'))

  file(tgt => src) do |t|
    attributes = {
      'basedir' => original_dir,
      'allow-uri-read' => true,
      'outdir' => outdir,
      'styledir' => original_dir,
      # 'stylesheet' => File.join(original_dir, 'html-theme.css'),
      # 'pdf-theme' => File.join(original_dir, 'pdf-theme.yml'),
      'source-highlighter' => 'rouge',
      'pdf-fontsdir' => File.join(original_dir, *%w{webdata engineering fonts})
    }
    
    # Asciidoctor::Compliance.unique_id_start_index = 1
    rake_output_message "Building HTML from #{t.source}..."

    # Render HTML5 file.
    Asciidoctor.convert_file(t.source, :safe => :unsafe, :mkdirs=> true, :to_dir => outdir, :attributes => attributes)
  end
end

pdfdocs = [
  [
    "#{JOURNAL}.adoc",
  ],
].flatten.map do |src|

  original_dir = Rake.application.original_dir
  outdir = File.dirname(File.absolute_path(src)).sub(original_dir, pdfdir)
  outdir = File.join(original_dir, outdir)
  tgt = File.join(outdir, File.basename(src).sub(/\.adoc$/, '.pdf'))

  file(tgt => src) do |t|
    attributes = {
      'basedir' => original_dir,
      'allow-uri-read' => true,
      'outdir' => outdir,
      'styledir' => original_dir,
      # 'stylesheet' => File.join(original_dir, 'html-theme.css'),
      # 'pdf-theme' => File.join(original_dir, 'pdf-theme.yml'),
      'source-highlighter' => 'rouge',
      # 'pdf-fontsdir' => File.join(original_dir, *%w{fonts})
    }
    
    # Asciidoctor::Compliance.unique_id_start_index = 1
    rake_output_message "Building PDF from #{t.source}..."

    # Render PDF file.
    Asciidoctor.convert_file(t.source, :backend => :pdf, :safe => :unsafe, :mkdirs=> true, :to_dir => outdir, :attributes => attributes)
  end
end

JOURNAL_CSS = <<EOF
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

EOF

JOURNAL_LOG = <<EOF

///////////////////////////////////
/// Journal
///////////////////////////////////

ifndef::included[]
= Journal
#{AUTHOR}
:toc: left
:toclevels: 6


== Introduction

A work journal.

endif::[]

== Feb 1 - 5, 2016

.February 1, 2016 - Monday
* An entry.

EOF

JOURNAL_TXT = <<EOF
= Main
#{AUTHOR}
:toc: left
:toclevels: 6
:stylesheet: #{JOURNAL}.css
// :linkcss:

[[journal_start]]
== Journal

:included: true
:leveloffset: 1

include::#{JOURNAL}_journal.adoc[]

:leveloffset: 0
:included!:

[[journal_end]]


EOF

task :htmldocs => [ directory(htmldir), *htmldocs ]

task :pdfdocs => [ directory(pdfdir), *pdfdocs ] 

task :init => [
  directory(htmldir),
  directory(pdfdir), 
  file("#{JOURNAL}.css") do |t|
    File.open(t.name, 'w') { |io| io.write(JOURNAL_CSS) }
  end,
  file("#{JOURNAL}_journal.adoc") do |t|
    File.open(t.name, 'w') { |io| io.write(JOURNAL_LOG) }
  end,
  file("#{JOURNAL}.adoc") do |t|
    File.open(t.name, 'w') { |io| io.write(JOURNAL_TXT) }
  end,
] 

task :default => [ :pdfdocs, :htmldocs ] 
