package ActivePerl::DocTools::TOC::HTML;

use strict;
use warnings;

use base 'ActivePerl::DocTools::TOC';

my $indent = '&nbsp;' x 4;

sub text {
    my $text =  join("\n", @_, "");
    return sub { $text };
}


# extra info is tedious to collect -- is done in a subclass or something.
sub extra { '' };

*header = text ("<hr><p>","<h4>Perl Core Documentation</h4>",);

# pod
sub before_pods { '' }

*pod_separator = text('<br>');

sub pod {
    my($self, $file) = @_;
    my $key = $^O eq "darwin" ? "pods::$file" : "Pod::$file";
    return _page($self->{pods}->{$key}, $file, $self->extra($file));
}

sub after_pods { '' }

# scripts
*before_scripts = text("<hr><p>","<h4>Programs</h4>",);

sub script {
    my($self, $file) = @_;
    return _page($self->{scripts}->{$file}, $file, $self->extra($file));
}

sub after_scripts { '' }

# pragmas
*before_pragmas = text("<hr><p>","<h4>Pragmas</h4>",);

sub pragma {
    my($self, $file) = @_;
    return _page($self->{pragmas}->{$file}, $file, $self->extra($file));
}

sub after_pragmas { '' }

# libraries
*before_libraries = text("<hr><p>","<h4>Modules</h4>",);

sub library_indent_open  { '' }  # text('<ul compact>');
sub library_indent_close { '' }  # text('</ul>');
sub library_indent_same  { '' }

sub library {
    my($self, $file, $showfile, $depth) = @_;
    return (($indent x $depth) . _page($self->{files}->{$file}, $showfile, $self->extra($file)));
}

sub library_container {
    my($self, $file, $showfile, $depth) = @_;
    return (($indent x $depth) . _folder($showfile));
}

sub after_libraries { '' }

*footer = text("</div></body></html>");


sub _folder {
    my($text) = @_;
    die "no argument to _folder!" unless defined $text;
    return qq'<img src="images/greysmallbullet.gif" width="5" height="5" alt="*"> $text<br>\n';
}

sub _page {
    my($href, $text, $extra) = @_;
    die "bad arguments to _page: ($href, $text, $extra)" unless defined $href and defined $text;
    $extra ||= '';
    $extra = " $extra" if $extra;  # just to make it EXACTLY identical to the old way. 
    return qq'<img src="images/greysmallbullet.gif" width="5" height="5" alt="*"> <a class="doc" href="$href">$text</a>$extra<br>\n';
}


sub boilerplate {
    return boiler_header() . boiler_links();
}

sub boiler_header {
    return <<'HERE';
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>

<head>
<!-- saved from url=(0017)http://localhost/ -->
<title>ActivePerl User Guide - Table of Contents</title>
<base target="PerlDoc">
<link rel="STYLESHEET" href="Active.css" type="text/css">
</head>

<body>

<h1>Table of Contents</h1>
HERE
}


sub boiler_links {
    my $retval = <<HERE;
<div nowrap>

<p><strong>Getting Started</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="perlmain.html">Welcome To ActivePerl</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="release.html">Release Notes</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="install.html">Installation Guide</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/ActivePerl-faq2.html">Using PPM</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
HERE
    $retval .= <<HERE if $^O eq "MSWin32";
<a class="doc" href="faq/Windows/ActivePerl-Winfaq6.html">Web Server Configuration</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
HERE
    $retval .= <<HERE;
<a class="doc" href="readme.html">Getting Started</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="changes-56.html">ActivePerl 5.6 Change Log</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="changes-58.html">ActivePerl 5.8 Change Log</a><br>
HERE
    $retval .= <<HERE if -e "$ActivePerl::DocTools::TOC::dirbase/unsupported.html";
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="unsupported.html">Unsupported Features</a><br>
HERE
    $retval .= <<HERE;
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="resources.html">More Resources</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Copyright.html">License and Copyright</a><br>


<strong>ActivePerl Components</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Components/Descriptions.html">Overview</a><br>
HERE
    my $site = "site/";
    $site = "" if -f "$ActivePerl::DocTools::TOC::dirbase/lib/Win32/OLE/Browser.html";

    $retval .= <<HERE if $^O eq "MSWin32";

&nbsp;&nbsp;&nbsp;&nbsp;<strong>Windows Specific</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="${site}lib/Win32/OLE/Browser.html" target="_blank">OLE Browser</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Components/Windows/PerlScript.html">PerlScript</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="../eg/IEExamples/index.htm">PerlScript Examples</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Components/Windows/PerlEz.html">PerlEz</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Components/Windows/PerlISAPI.html">Perl for ISAPI</a><br>
HERE
    $retval .= PerlEx_links();
    $retval .= <<HERE;

<strong>ActivePerl FAQ</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/ActivePerl-faq.html">Introduction</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/ActivePerl-faq1.html">Availability &amp; Install</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/ActivePerl-faq3.html">Docs &amp; Support</a><br>
HERE
    $retval .= <<HERE if $^O eq "MSWin32";

&nbsp;&nbsp;&nbsp;&nbsp;<strong>Windows Specific</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq2.html">Perl for ISAPI</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq4.html">Windows 9X/Me/NT/200X/XP</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq5.html">Windows Quirks</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq7.html">Web Programming</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq8.html">Windows Programming</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq9.html">Modules &amp; Samples</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq10.html">Embedding &amp; Extending</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="faq/Windows/ActivePerl-Winfaq12.html">Using OLE with Perl</a><br>

<strong>Windows Scripting</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Windows/ActiveServerPages.html">Active Server Pages</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Windows/WindowsScriptHost.html">Windows Script Host</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="Windows/WindowsScriptComponents.html">Windows Script Components</a></p>


HERE
    return $retval;
}

sub PerlEx_links {
    return "" unless -e "$ActivePerl::DocTools::TOC::dirbase/PerlEx/Welcome.html";

    return <<HERE;

&nbsp;&nbsp;&nbsp;&nbsp;<strong>PerlEx</strong><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Getting Started</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Welcome.html">Welcome</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/QuickStart.html">Getting Started</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/HowItWorks.html">How PerlEx Works</a><br>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Configuration</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/WebServerConfig.html">WebServer Configuration</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/IntrpClass.html">PerlEx Interpreter Classes</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/RegistryEntries.html">PerlEx Registry Entries</a><br>
<!--
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/PerfMon.html">Performance Monitor</a><br>
-->
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Debugging.html">Debugging PerlEx Scripts</a><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Features</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/BEGIN-ENDBlocks.html">BEGIN and END Blocks</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/PersistentConnections.html">Persistent Connections</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Embedded.html">Embedding Perl in HTML files</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Reload.html">Reload &amp; ReloadAll</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/PerlExCoding.html">Coding with PerlEx</a><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Reference</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/FAQ.html">PerlEx FAQ</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Troubleshooting.html">Troubleshooting</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Precompiler.html">PerlEx Precompiler</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/ErrorMessages.html">Event Log and Error Messages</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="PerlEx/Bugs.html">Reporting Bugs</a><br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Examples</strong><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="http://localhost/PerlEx/examples.aspl">Examples</a><br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/greysmallbullet.gif" width="5" height="5" alt="*">
<a class="doc" href="http://localhost/PerlEx/bm.htm">Benchmarks</a><br>
HERE
}

1;
