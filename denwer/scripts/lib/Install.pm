## +-------------------------------------------------------------------------+
## | ─цхэЄы№ьхэёъшщ эрсюЁ Web-ЁрчЁрсюЄўшър                                   |
## | ┬хЁёш : ─хэтхЁ-3 2007-11-23                                             |
## +-------------------------------------------------------------------------+
## | Copyright (C) 2001-2007 ─ьшЄЁшщ ╩юЄхЁют.                                |
## +-------------------------------------------------------------------------+
## | ─рээ√щ Їрщы  ты хЄё  ўрёЄ№■ ъюьяыхъёр яЁюуЁрьь "─хэтхЁ-3". ┬√ эх ьюцхЄх |
## | шёяюы№чютрЄ№  хую т ъюььхЁўхёъшї  Ўхы ї.  ═шъръшх фЁєушх юуЁрэшўхэш  эх |
## | эръырф√тр■Єё .  ┼ёыш т√ їюЄшЄх тэхёЄш шчьхэхэш  т шёїюфэ√щ ъюф,  ртЄюЁ√ |
## | сєфєЄ Ёрф√ яюыєўшЄ№ юЄ трё ъюььхэЄрЁшш ш чрьхўрэш . ╧Ёш Єэющ ЁрсюЄ√!    |
## +-------------------------------------------------------------------------+
## | ─юьр°э   ёЄЁрэшЎр: http://denwer.ru                                     |
## | ╩юэЄръЄ√: http://forum.dklab.ru/denwer                                  |
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
	print "┌────────────────────────────────────────────────────────────┐\n";
	print "│ Поиск корневой директории установленного Денвера (той, где │\n";
	print "│ расположены папки home, denwer, usr и т.д.).               │\n";
	print "└────────────────────────────────────────────────────────────┘\n";
	print "Ждите... ";
        my ($path) = search4Root();
	if(!$path) {
		print "Установленный Денвер не найден ни на одном диске!\n\n";
		while(1) {
			print "Введите полный путь к директории Денвера вручную.\nПуть: ";
			$path = <STDIN> || '';
			$path=~s/^\s+|\s+$//sg;
			if(!dirLikeRoot($path)) {
				print "Эта директория не является корневой для Денвера.\n\n";
			} else {
				if(checkRootVersion($path)) {
					last;
				} else {
					print "В этой директории установлена слишком старая версия Денвера.\n\n";
				}
			}
		}
	}
	print "Денвер обнаружен в $path\n\n";
	return $path;
}


# void checkManif(\*FH)
# Checks if all the files presented.
sub checkManif {
    my ($data)=@_;
    print "╔═══════════════════════════════════════╗\n";
    print "║ Проверяем целостность дистрибутива... ║\n";
    print "╚═══════════════════════════════════════╝\n";
    while(defined($_=<$data>)) {
		s/^#.*|^\s+|\s+$//sg; next if $_ eq "";
		next if -e $_;
		print "Ошибка!\n";
		if(m{/$}) {
			print "Не удалось найти директорию $_!\nПроверьте, правильно ли вы развернули архив.\n";
		} else {
			print "Не удалось найти файл $_!\nПроверьте, правильно ли вы развернули архив.\n";
		}
		print "Нажмите Enter... "; <STDIN>; 
		exit(1);
	}	
#	print "Все файлы на месте. Продолжаем...\n\n";
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

	# Слишком глубоко.
	return undef if ($dep||0)>$maxDep;

	# Если dir==undef, то ищем по всем дискам.
	my @cont=();
	if(defined $dir) {
		# Завершающий \ дальше ОБЯЗАТЕЛЕН!!!
		opendir(local *D,"$dir\\") or return;
		@cont=readdir(D);
	} else {
		@cont = map { chr($_).":" } (ord('C')..ord('Z'));
	}

	# Сначала ищем на $dep-ном уровне.
	my @subs=();
	foreach my $e (@cont) {
		next if $e=~/^\./;
		my $full=(defined $dir)? "$dir\\$e" : $e . "\\"; 
		$full =~ s/\\\\/\\/sg;

		# Печатаем путь без перемещения курсора.
		my $s=$full.(" "x(40-length($full)));
		print $s.("\b"x(length $s));

		next if !-d $full;

		if(dirLikeRoot($full)) {
			print "\n";
			if(my $v=checkRootVersion($full)) {
				print "Денвер v.$v найден в директории $full.\n";
				print "Использовать ее для установки (y/n)? ";
				return $full if readYesNo();
				print "Продолжаем поиск: ";
			} else {
				print "Найдена предыдущая версия, пропускаем.\n";
				print "Продолжаем поиск: ";
			}
		}
		push @subs, $full;
	}	

	# Затем спускаемся на уровень ниже.
	foreach my $full (@subs) {
		my $d=search4Root($full,($dep||0)+1);
		return $d if $d;
	}

	print "не найдено.\n" if !$dep;

	return undef;
}


# bool readYesNo()
# Read user's "Yes" or "No" answer. Returns true of user entered "Yes".
sub readYesNo {
	my $yn;
	while(1) {
		$yn=lc(scalar <STDIN>);
		$yn=~s/^\s+|\s+$//gs;
		if($yn ne "y" && $yn ne "n" && $yn ne "да" && $yn ne "нет") {
			print "\x07Введите \"y\" (Да) или \"n\" (Нет): ";
			next;
		}
		return $yn eq "y" || $yn eq "да" || 0;
	}
}


return 1;
