@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!/usr/bin/perl -w
#line 15

# This script will open up the ActivePerl User Guide in your
# web browser.

use strict;
use Config qw(%Config);

my $htmldir = $Config{installhtmldir} || "$Config{prefix}/html";
my $index = "$htmldir/index.html";

die "No HTML docs installed at $htmldir\n"
    unless -f $index;

require ActiveState::Browser;
ActiveState::Browser::open($index);

__END__
:endofperl
