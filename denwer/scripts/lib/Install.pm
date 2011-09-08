## +-------------------------------------------------------------------------+
## | �������������� ����� Web-������������                                   |
## | ������: ������-3 2007-11-23                                             |
## +-------------------------------------------------------------------------+
## | Copyright (C) 2001-2007 ������� �������.                                |
## +-------------------------------------------------------------------------+
## | ������ ���� �������� ������ ��������� �������� "������-3". �� �� ������ |
## | ������������  ��� � ������������  �����.  ������� ������ ����������� �� |
## | �������������.  ���� �� ������ ������ ��������� � �������� ���,  ������ |
## | ����� ���� �������� �� ��� ����������� � ���������. �������� ������!    |
## +-------------------------------------------------------------------------+
## | �������� ��������: http://denwer.ru                                     |
## | ��������: http://forum.dklab.ru/denwer                                  |
## +-------------------------------------------------------------------------+
##
## This file is used by package installers.
## Please do not delete it.
##

# How deep to search for the base package.
my $maxDep = 1;

# Current version.
my $VERSION = 3.00;


# string searchBase()
# Search for base package on drive (not very deep).
sub searchBase {
	print "������������������������������������������������������������Ŀ\n";
	print "� ���� ��୥��� ��४�ਨ ��⠭��������� ������ (⮩, ��� �\n";
	print "� �ᯮ������ ����� home, denwer, usr � �.�.).               �\n";
	print "��������������������������������������������������������������\n";
	print "����... ";
        my ($path) = search4Root();
	if(!$path) {
		print "��⠭������� ������ �� ������ �� �� ����� ��᪥!\n\n";
		while(1) {
			print "������ ����� ���� � ��४�ਨ ������ ������.\n����: ";
			$path = <STDIN> || '';
			$path=~s/^\s+|\s+$//sg;
			if(!dirLikeRoot($path)) {
				print "�� ��४��� �� ���� ��୥��� ��� ������.\n\n";
			} else {
				if(checkRootVersion($path)) {
					last;
				} else {
					print "� �⮩ ��४�ਨ ��⠭������ ᫨誮� ���� ����� ������.\n\n";
				}
			}
		}
	}
	print "������ �����㦥� � $path\n\n";
	return $path;
}


# void checkManif(\*FH)
# Checks if all the files presented.
sub checkManif {
    my ($data)=@_;
    print "���������������������������������������ͻ\n";
    print "� �஢��塞 楫��⭮��� ����ਡ�⨢�... �\n";
    print "���������������������������������������ͼ\n";
    while(defined($_=<$data>)) {
		s/^#.*|^\s+|\s+$//sg; next if $_ eq "";
		next if -e $_;
		print "�訡��!\n";
		if(m{/$}) {
			print "�� 㤠���� ���� ��४��� $_!\n�஢����, �ࠢ��쭮 �� �� ࠧ���㫨 ��娢.\n";
		} else {
			print "�� 㤠���� ���� 䠩� $_!\n�஢����, �ࠢ��쭮 �� �� ࠧ���㫨 ��娢.\n";
		}
		print "������ Enter... "; <STDIN>; 
		exit(1);
	}	
#	print "�� 䠩�� �� ����. �த������...\n\n";
}


# bool dirLikeRoot($dir)
# Returns true if $dir seems to be root.
sub dirLikeRoot
{	my ($dir)=@_;
	return undef if !defined $dir;
	opendir(local *D,"$dir/"); my @cur=readdir(D); closedir(D);
	$dir=~s{[/\\]+$}{}s;
	return scalar(
		(grep { -d "$dir/$_" && lc $_ eq "home" } @cur) &&
		(grep { -d "$dir/$_" && lc $_ eq "usr"  } @cur) &&
		(grep { -d "$dir/$_" && lc $_ eq "denwer"  } @cur)
	);
}


# bool checkRootVersion($dir)
# Returns true if $dir seems to be root and has correct version.
sub checkRootVersion
{	my ($dir)=@_;
	return if !dirLikeRoot($dir);
	open(local *F, "$dir/denwer/scripts/lib/StartManager.pm") or return;
	local $/;
	$_=<F>;
	my ($v) = m/\$VERSION\s*=\s*['"]?([0-9a-z_.]+)['"]?\s*;/s or return;
	return int($v) eq int($VERSION)? $v : undef;
}


# string search4Root($dir)
# Search for root directory. Returns undef if failed.
sub search4Root
{	my ($dir,$dep)=@_;

	# ���誮� ��㡮��.
	return undef if ($dep||0)>$maxDep;

	# �᫨ dir==undef, � �饬 �� �ᥬ ��᪠�.
	my @cont=();
	if(defined $dir) {
		# �������騩 \ ����� ����������!!!
		opendir(local *D,"$dir\\") or return;
		@cont=readdir(D);
	} else {
		@cont = map { chr($_).":" } (ord('C')..ord('Z'));
	}

	# ���砫� �饬 �� $dep-��� �஢��.
	my @subs=();
	foreach my $e (@cont) {
		next if $e=~/^\./;
		my $full=(defined $dir)? "$dir\\$e" : $e . "\\"; 
		$full =~ s/\\\\/\\/sg;

		# ���⠥� ���� ��� ��६�饭�� �����.
		my $s=$full.(" "x(40-length($full)));
		print $s.("\b"x(length $s));

		next if !-d $full;

		if(dirLikeRoot($full)) {
			print "\n";
			if(my $v=checkRootVersion($full)) {
				print "������ v.$v ������ � ��४�ਨ $full.\n";
				print "�ᯮ�짮���� �� ��� ��⠭���� (y/n)? ";
				return $full if readYesNo();
				print "�த������ ����: ";
			} else {
				print "������� �।���� �����, �ய�᪠��.\n";
				print "�த������ ����: ";
			}
		}
		push @subs, $full;
	}	

	# ��⥬ ��᪠���� �� �஢��� ����.
	foreach my $full (@subs) {
		my $d=search4Root($full,($dep||0)+1);
		return $d if $d;
	}

	print "�� �������.\n" if !$dep;

	return undef;
}


# bool readYesNo()
# Read user's "Yes" or "No" answer. Returns true of user entered "Yes".
sub readYesNo {
	my $yn;
	while(1) {
		$yn=lc(scalar <STDIN>);
		$yn=~s/^\s+|\s+$//gs;
		if($yn ne "y" && $yn ne "n" && $yn ne "��" && $yn ne "���") {
			print "\x07������ \"y\" (��) ��� \"n\" (���): ";
			next;
		}
		return $yn eq "y" || $yn eq "��" || 0;
	}
}


return 1;
