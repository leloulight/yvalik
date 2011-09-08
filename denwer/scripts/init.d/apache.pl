#!perl -w
# +-------------------------------------------------------------------------+
# | Äæåíòëüìåíñêèé íàáîð Web-ðàçðàáîò÷èêà                                   |
# | Âåðñèÿ: Äåíâåð-3 2008-01-13                                             |
# +-------------------------------------------------------------------------+
# | Copyright (C) 2001-2007 Äìèòðèé Êîòåðîâ.                                |
# +-------------------------------------------------------------------------+
# | Äàííûé ôàéë ÿâëÿåòñÿ ÷àñòüþ êîìïëåêñà ïðîãðàìì "Äåíâåð-3". Âû íå ìîæåòå |
# | èñïîëüçîâàòü  åãî â êîììåð÷åñêèõ  öåëÿõ.  Íèêàêèå äðóãèå îãðàíè÷åíèÿ íå |
# | íàêëàäûâàþòñÿ.  Åñëè âû õîòèòå âíåñòè èçìåíåíèÿ â èñõîäíûé êîä,  àâòîðû |
# | áóäóò ðàäû ïîëó÷èòü îò âàñ êîììåíòàðèè è çàìå÷àíèÿ. Ïðèÿòíîé ðàáîòû!    |
# +-------------------------------------------------------------------------+
# | Äîìàøíÿÿ ñòðàíèöà: http://denwer.ru                                     |
# | Êîíòàêòû: http://forum.dklab.ru/denwer                                  |
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
    print "‡ ¯ãáª ¥¬ Apache...\n";
    if(checkApacheIfRunning()) {
      print "  Apache ã¦¥ § ¯ãé¥­.\n";
    } else {
      chdir($basedir);
      my $exe = $exe;
      if(!-f $exe) {
        die "  ¥ ã¤ ¥âáï ­ ©â¨ $exe.\n";
      } else {
        # Clean global error.log to avoid stupid PHP "C:\mysql" binding.
        unlink("$basedir/logs/error.log");
        # Start apache.
        system("start $exe -w");
        print "  ƒ®â®¢®.\n";
      }
    }
  },
  stop => sub {
    ###
    ### STOP.
    ###
    print "‡ ¢¥àè ¥¬ à ¡®âã Apache...\n";
    my $exe = $exe;
    if(!-f $exe) {
      print "  ¥ ã¤ ¥âáï ­ ©â¨ $exe.\n";
    } else {
      my $was = checkApacheIfRunning();
      # ’ã¯®© Apache2 ­¥ ã¬¥¥â § ¢¥àè âìáï ¯® -k shutdown!
      # ®íâ®¬ã ¯à¨å®¤¨âáï ¯à¨¡¨¢ âì ¢àãç­ãî. ƒàï§­®, ª®­¥ç­®.
      # Šáâ â¨, Parent ID ã ¯à®æ¥áá  ­¥«ì§ï ¯®«ãç¨âì ¢ Windows NT Workststion.
      my $ps = getPs(1);
      if ($ps) {
        foreach (@$ps) {
          next if $_->{exe} !~ /\b(apache|httpd)\.exe$/is;
          kill 9, $_->{pid};
        }
      } else {
        print "  ¥ ã¤ ¥âáï ­ ©â¨ ãâ¨«¨âã ps.exe.\n";
      }
#      system("\"$exe\" -k shutdown");
      if($was) {
        unlink($httpd_pid);     
        print "  ƒ®â®¢®.\n";
      } else {
        print "  Apache ­¥ § ¯ãé¥­.\n";
      }
    }
  },
  _middle => sub {
    my $tm = time();
    if(checkApacheIfRunning()) {
      print "Ž¦¨¤ ¥¬ § ¢¥àè¥­¨ï Apache (¬ ªá¨¬ã¬ $timeout á¥ªã­¤) ";
      while(time() - $tm < $timeout) {
        print ". ";
        if(!checkApacheIfRunning()) {
          print "\n";
          return;
        }
        sleep(1);
      }
      print "\n";
      print "  ¥ ã¤ ¥âáï ¤®¦¤ âìáï § ¢¥àè¥­¨ï!\n";
    }
  },
;


sub processVHosts {
  my $VHOSTS = $vhosts_conf;
  my $HTTPD = $httpd_conf;

  print "‘®§¤ ¥¬ ¡«®ª¨ ¢¨àâã «ì­ëå å®áâ®¢...\n";

  if(!-e $HTTPD) {
    die "  ¥ ã¤ ¥âáï ­ ©â¨ $HTTPD\n";
  }

  # Add comments.
  my $vhosts = '';
  $vhosts .= clean qq{
    #
    # ÂÍÈÌÀÍÈÅ!
    #
    # Äàííûé ôàéë áûë ñãåíåðèðîâàí àâòîìàòè÷åñêè. Ëþáûå èçìåíåíèÿ, âíåñåííûå â 
    # íåãî, ïîòåðÿþòñÿ ïîñëå ïåðåçàïóñêà êîìïëåêñà. Åñëè âû õîòèòå èçìåíèòü
    # ïàðàìåòðû êàêîãî-òî îòäåëüíîãî õîñòà, âàì íåîáõîäèìî ïåðåíåñòè 
    # ñîîòâåòñòâóþùèé áëîê <VirtualHost> â httpd.conf (òàì íàïèñàíî, êóäà èìåííî).
    #
    # Ïîæàëóéñòà, íå èçìåíÿéòå ýòîò ôàéë.
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

    # ‚áâ ¢«ï¥¬ ¡ãª¢ã ¤¨áª  - ¯à®ª«ïâë¥ à §à ¡®âç¨ª¨ PHP ¡¥§ íâ®£® ­¥ ¬®£ãâ ­¨ª ª!
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
      ‚ˆŒ€ˆ…!
      ¥ ã¤ ¥âáï ®âªàëâì ä ©« $VHOSTS ­  § ¯¨áì. 
      à®¤®«¦¥­¨¥ à ¡®âë ­¥¢®§¬®¦­®.
    };
    waitEnter();
    die "\n";
  }
  print F $vhosts;
  close F;
  
  print "  „®¡ ¢«¥­® å®áâ®¢: ".($num-1)."\n";
}

sub checkApacheIfRunning {
  return !open(local *F, ">>$exe");
}

return 1 if caller;
