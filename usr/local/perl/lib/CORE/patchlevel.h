/*    patchlevel.h
 *
 *    Copyright (C) 1993, 1995, 1996, 1997, 1998, 1999,
 *    2000, 2001, 2002, 2003, 2004, 2005, 2006, by Larry Wall and others
 *
 *    You may distribute under the terms of either the GNU General Public
 *    License or the Artistic License, as specified in the README file.
 *
 */

#ifndef __PATCHLEVEL_H_INCLUDED__

#include "BuildInfo.h"

/* do not adjust the whitespace! Configure expects the numbers to be
 * exactly on the third column */

#define PERL_REVISION	5		/* age */
#define PERL_VERSION	8		/* epoch */
#define PERL_SUBVERSION	8		/* generation */

/* The following numbers describe the earliest compatible version of
   Perl ("compatibility" here being defined as sufficient binary/API
   compatibility to run XS code built with the older version).
   Normally this should not change across maintenance releases.

   Note that this only refers to an out-of-the-box build.  Many non-default
   options such as usemultiplicity tend to break binary compatibility
   more often.

   This is used by Configure et al to figure out 
   PERL_INC_VERSION_LIST, which lists version libraries
   to include in @INC.  See INSTALL for how this works.
*/
#define PERL_API_REVISION	5	/* Adjust manually as needed.  */
#define PERL_API_VERSION	8	/* Adjust manually as needed.  */
#define PERL_API_SUBVERSION	0	/* Adjust manually as needed.  */
/*
   XXX Note:  The selection of non-default Configure options, such
   as -Duselonglong may invalidate these settings.  Currently, Configure
   does not adequately test for this.   A.D.  Jan 13, 2000
*/

#define __PATCHLEVEL_H_INCLUDED__
#endif

/*
	local_patches -- list of locally applied less-than-subversion patches.
	If you're distributing such a patch, please give it a name and a
	one-line description, placed just before the last NULL in the array
	below.  If your patch fixes a bug in the perlbug database, please
	mention the bugid.  If your patch *IS* dependent on a prior patch,
	please place your applied patch line after its dependencies. This
	will help tracking of patch dependencies.

	Please either use 'diff --unified=0' if your diff supports
	that or edit the hunk of the diff output which adds your patch
	to this list, to remove context lines which would give patch
	problems. For instance, if the original context diff is

	   *** patchlevel.h.orig	<date here>
	   --- patchlevel.h	<date here>
	   *** 38,43 ***
	   --- 38,44 ---
	     	,"FOO1235 - some patch"
	     	,"BAR3141 - another patch"
	     	,"BAZ2718 - and another patch"
	   + 	,"MINE001 - my new patch"
	     	,NULL
	     };
	
	please change it to 
	   *** patchlevel.h.orig	<date here>
	   --- patchlevel.h	<date here>
	   *** 41,43 ***
	   --- 41,44 ---
	   + 	,"MINE001 - my new patch"
	     	,NULL
	     };
	
	(Note changes to line numbers as well as removal of context lines.)
	This will prevent patch from choking if someone has previously
	applied different patches than you.

        History has shown that nobody distributes patches that also
        modify patchlevel.h. Do it yourself. The following perl
        program can be used to add a comment to patchlevel.h:

#!perl
die "Usage: perl -x patchlevel.h comment ..." unless @ARGV;
open PLIN, "patchlevel.h" or die "Couldn't open patchlevel.h : $!";
open PLOUT, ">patchlevel.new" or die "Couldn't write on patchlevel.new : $!";
my $seen=0;
while (<PLIN>) {
    if (/\t,NULL/ and $seen) {
       while (my $c = shift @ARGV){
            print PLOUT qq{\t,"$c"\n};
       }
    }
    $seen++ if /local_patches\[\]/;
    print PLOUT;
}
close PLOUT or die "Couldn't close filehandle writing to patchlevel.new : $!";
close PLIN or die "Couldn't close filehandle reading from patchlevel.h : $!";
close DATA; # needed to allow unlink to work win32.
unlink "patchlevel.bak" or warn "Couldn't unlink patchlevel.bak : $!"
  if -e "patchlevel.bak";
rename "patchlevel.h", "patchlevel.bak" or
  die "Couldn't rename patchlevel.h to patchlevel.bak : $!";
rename "patchlevel.new", "patchlevel.h" or
  die "Couldn't rename patchlevel.new to patchlevel.h : $!";
__END__

Please keep empty lines below so that context diffs of this file do
not ever collect the lines belonging to local_patches() into the same
hunk.

 */




#if !defined(PERL_PATCHLEVEL_H_IMPLICIT) && !defined(LOCAL_PATCH_COUNT)
static const char *local_patches[] = {
        NULL
	,ACTIVEPERL_LOCAL_PATCHES_ENTRY
#  if !defined(PERL_DARWIN)     
        ,"Iin_load_module moved for compatibility with build 806"
#  endif
#  if defined(__hpux)
        ,"Avoid signal flag SA_RESTART for older versions of HP-UX"
#  endif
        ,"PerlEx support in CGI::Carp"
        ,"Less verbose ExtUtils::Install and Pod::Find"
        ,"Patch for CAN-2005-0448 from Debian with modifications"
	,"Rearrange @INC so that 'site' is searched before 'perl'"
	,"Partly reverted 24733 to preserve binary compatibility"
#  if defined(WIN32)
        ,"29930 win32.c typo in #define MULTIPLICITY"
        ,"29868 win32_async_check() can still loop indefinitely"
        ,"29690,29732 ANSIfy the PATH environment variable on Windows"
        ,"29689 Add error handling to win32_ansipath"
        ,"29675 Use short pathnames in $^X and @INC"
        ,"29607,29676 allow blib.pm to be used for testing Win32 module"
        ,"29605 Implement killpg() for MSWin32"
        ,"29598 cwd() to return the short pathname"
        ,"29597 let readdir() return the alternate filename"
        ,"29590 Don't destroy the Unicode system environment on Perl startup"
        ,"29528 get ext/Win32/Win32.xs to compile on cygwin"
        ,"29509,29510,29511 Move Win32::* functions into Win32 module"
        ,"29483 Move Win32 from win32/ext/Win32 to ext/Win32"
        ,"29481 Makefile.PL changes to compile Win32.xs using cygwin"
        ,"28671 Define PERL_NO_DEV_RANDOM on Windows"
#  endif
	,"28376 Add error checks after execing PL_cshname or PL_sh_path"
	,"28305 Pod::Html should not convert \"foo\" into ``foo''"
        ,"27833 Change anchor generation in Pod::Html for '=item item 2'"
        ,"27832,27847 fix Pod::Html::depod() for multi-line strings"
#  if defined(__sun) && !defined(__GNUC__)
	,"27736 Make perl_fini() run with Sun WorkShop compiler"
#  endif
        ,"27719 Document the functions htmlify() and anchorify() in Pod::Html"
        ,"27619 Bug in Term::ReadKey being triggered by a bug in Term::ReadLine"
	,"27549 Move DynaLoader.o into libperl.so"
#  if defined(WIN32)
        ,"27528 win32_pclose() error exit doesn't unlock mutex"
        ,"27527 win32_async_check() can loop indefinitely"
#  endif
	,"27515 ignore directories when searching @INC"
        ,"27359 Fix -d:Foo=bar syntax"
	,"27210 Fix quote typo in c2ph"
	,"27203 Allow compiling swigged C++ code"
#  if defined(WIN32)
	,"27200 Make stat() on Windows handle trailing slashes correctly"
#  endif
#  if defined(__hpux)
	,"27194 Get perl_fini() running on HP-UX again"
#  endif
	,"27133 Initialise lastparen in the regexp structure"
        ,"27061 L<PerlIO> and Pod::Html"
	,"27034 Avoid \"Prototype mismatch\" warnings with autouse"
        ,"26970 Make Passive mode the default for Net::FTP"
	,"26921 Avoid getprotobyname/number calls in IO::Socket::INET"
	,"26897,26903 Make common IPPROTO_* constants always available"
        ,"26670 Make '-s' on the shebang line parse -foo=bar switches"
#  if defined(WIN32)
        ,"26637 Make Borland and MinGW happy with change 26379"
#  endif
	,"26536 INSTALLSCRIPT versus INSTALLDIRS"
#  if defined(WIN32)
        ,"26379 Fix alarm() for Windows 2003"
#  endif
        ,"26087 Storable 0.1 compatibility"
	,"25861 IO::File performace issue"
	,"25084 long groups entry could cause memory exhaustion"
        ,"24699 ICMP_UNREACHABLE handling in Net::Ping"
	,NULL
};



/* Initial space prevents this variable from being inserted in config.sh  */
#  define	LOCAL_PATCH_COUNT	\
	(sizeof(local_patches)/sizeof(local_patches[0])-2)

/* the old terms of reference, add them only when explicitly included */
#define PATCHLEVEL		PERL_VERSION
#undef  SUBVERSION		/* OS/390 has a SUBVERSION in a system header */
#define SUBVERSION		PERL_SUBVERSION
#endif
