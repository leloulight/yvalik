#!perl -w
# +-------------------------------------------------------------------------+
# | �������������� ����� Web-������������                                   |
# | ������: ������-3 2008-01-13                                             |
# +-------------------------------------------------------------------------+
# | Copyright (C) 2001-2007 ������� �������.                                |
# +-------------------------------------------------------------------------+
# | ������ ���� �������� ������ ��������� �������� "������-3". �� �� ������ |
# | ������������  ��� � ������������  �����.  ������� ������ ����������� �� |
# | �������������.  ���� �� ������ ������ ��������� � �������� ���,  ������ |
# | ����� ���� �������� �� ��� ����������� � ���������. �������� ������!    |
# +-------------------------------------------------------------------------+
# | �������� ��������: http://denwer.ru                                     |
# | ��������: http://forum.dklab.ru/denwer                                  |
# +-------------------------------------------------------------------------+

package Starters::Apache;
BEGIN { unshift @INC, "../lib"; }

use Tools;
use Installer;
use ParseHosts;
use VhostTemplate;
use StartManager;

# Seconds to wait apache stop while restart is active.
my $timeout = 10;

# Get common pathes.
my $basedir     = $CNF{apache_dir};
my $exe         = fsgrep { /\Q$CNF{apache_exe}\E/i } $basedir;
die "  Could not find $CNF{apache_exe} inside $basedir\n" if !$exe;
my $httpd_conf  = "$basedir/conf/httpd.conf";
my $vhosts_conf = "$basedir/conf/vhosts.conf";
my $httpd_pid   = "$basedir/logs/httpd.pid";


# Additional PATH entries.
my @addPath = ();

# Autoconfigure PHP - detect basedir from LoadModule in httpd.conf file.
my $phpdir = undef;
my $httpdCont = readBinFile($httpd_conf) or die "  Could not read $httpd_conf\n";
if ($httpdCont =~ /^[ \t]* LoadModule [ \t]+ php\S*_module [ \t]+ (?: "([^"\r\n]*)" | (\S+) )/mix) {
  my $path = dirname($1 || $2);
  if (my $p1 = dirgrep { /^php.ts\.dll$/i } $path) {
    $phpdir = dirname($p1);
  } elsif (my $p2 = dirgrep { /^php.ts\.dll$/i } "$path/..") {
    $phpdir = dirname($p2);
  }
}
if ($phpdir) {
  # PHP configuration file location.
  $ENV{PHPRC} = $phpdir;
  # For OpenSSL module in PHP.
  if (my $p = fsgrep { /^openssl.cnf$/i } $phpdir) {
    $ENV{OPENSSL_CONF} = $p;
  }
  # Set PATH.
  push @addPath, ($phpdir, fsgrep { /^extensions$/i || /^dlls$/i } $phpdir);
}


StartManager::action 
  $ARGV[0],
  PATH => [
  	'\usr\local\ImageMagick',
  	@addPath,
  ],
  start => sub {
    ###
    ### START.
    ###
    processVHosts();
    print "����᪠�� Apache...\n";
    if(checkApacheIfRunning()) {
      print "  Apache 㦥 ����饭.\n";
    } else {
      chdir($basedir);
      my $exe = $exe;
      if(!-f $exe) {
        die "  �� 㤠���� ���� $exe.\n";
      } else {
        # Clean global error.log to avoid stupid PHP "C:\mysql" binding.
        unlink("$basedir/logs/error.log");
        # Start apache.
        system("start $exe -w");
        print "  ��⮢�.\n";
      }
    }
  },
  stop => sub {
    ###
    ### STOP.
    ###
    print "�����蠥� ࠡ��� Apache...\n";
    my $exe = $exe;
    if(!-f $exe) {
      print "  �� 㤠���� ���� $exe.\n";
    } else {
      my $was = checkApacheIfRunning();
      # �㯮� Apache2 �� 㬥�� ���������� �� -k shutdown!
      # ���⮬� ��室���� �ਡ����� ������. ��吝�, ����筮.
      # ����, Parent ID � ����� ����� ������� � Windows NT Workststion.
      my $ps = getPs(1);
      if ($ps) {
        foreach (@$ps) {
          next if $_->{exe} !~ /\b(apache|httpd)\.exe$/is;
          kill 9, $_->{pid};
        }
      } else {
        print "  �� 㤠���� ���� �⨫��� ps.exe.\n";
      }
#      system("\"$exe\" -k shutdown");
      if($was) {
        unlink($httpd_pid);     
        print "  ��⮢�.\n";
      } else {
        print "  Apache �� ����饭.\n";
      }
    }
  },
  _middle => sub {
    my $tm = time();
    if(checkApacheIfRunning()) {
      print "������� �����襭�� Apache (���ᨬ� $timeout ᥪ㭤) ";
      while(time() - $tm < $timeout) {
        print ". ";
        if(!checkApacheIfRunning()) {
          print "\n";
          return;
        }
        sleep(1);
      }
      print "\n";
      print "  �� 㤠���� ��������� �����襭��!\n";
    }
  },
;


sub processVHosts {
  my $VHOSTS = $vhosts_conf;
  my $HTTPD = $httpd_conf;

  print "������� ����� ����㠫��� ��⮢...\n";

  if(!-e $HTTPD) {
    die "  �� 㤠���� ���� $HTTPD\n";
  }

  # Add comments.
  my $vhosts = '';
  $vhosts .= clean qq{
    #
    # ��������!
    #
    # ������ ���� ��� ������������ �������������. ����� ���������, ��������� � 
    # ����, ���������� ����� ����������� ���������. ���� �� ������ ��������
    # ��������� ������-�� ���������� �����, ��� ���������� ��������� 
    # ��������������� ���� <VirtualHost> � httpd.conf (��� ��������, ���� ������).
    #
    # ����������, �� ��������� ���� ����.
    #
  };

  # Read Vhost template
  my $num = 1;
  foreach my $host (VhostTemplate::getAllVHosts($HTTPD)) {
#    use Data::Dumper; print Dumper($host);
    $vhosts .= "\n\n# Host ".$host->{path}." ($num): \n";

    my $s = $host->{vhost};
    # Delete comments.
    $s=~s/#.*//mg if $num!=1;
    $s=~s/^[ \t]*[\r\n]+//mg;    # delete empty lines

    # ��⠢�塞 �㪢� ��᪠ - �ப���� ࠧࠡ��稪� PHP ��� �⮣� �� ����� �����!
    $s=~s{^(\s* DocumentRoot \s+ "?)(/)}{$1 . Installer::getSubstDriveConfig() . $2}mgxie;

    $vhosts .= $s;
  } continue {
    $num++;
  }

  # Remove duplicate Listen directives.
  my %dup = ();
  $vhosts =~ s{^\s* Listen \s+ "? ([^\s"]+) "?}{ ($dup{lc $1}++)? '#'.$& : $& }megx;

  # Remove duplicate NameVirtualHost.
  %dup = ();
  $vhosts =~ s{^\s* NameVirtualHost \s+ "? ([^\s"]+) "?}{ ($dup{lc $1}++)? '#'.$& : $& }megx;
  
  # Open output file.
  if(!open(local *F, ">$VHOSTS")) {
    out qq{
      ��������!
      �� 㤠���� ������ 䠩� $VHOSTS �� ������. 
      �த������� ࠡ��� ����������.
    };
    waitEnter();
    die "\n";
  }
  print F $vhosts;
  close F;
  
  print "  ��������� ��⮢: ".($num-1)."\n";
}

sub checkApacheIfRunning {
  return !open(local *F, ">>$exe");
}

return 1 if caller;
