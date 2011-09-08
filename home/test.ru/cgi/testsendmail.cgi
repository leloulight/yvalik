#!/usr/bin/perl
# �������� �� ������ ���� � Perl �� ����� �������

read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
@pairs=split(/&/,$buffer);
foreach $pair (@pairs) {
 ($name,$value)=split(/=/,$pair);
 $name=~tr/+/ /;
 $name=~s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
 $value=~tr/+/ /;
 $value=~s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
 $FORM{$name}=$value;
}

if ($FORM{'step'} eq '') {
 $out_str=<<"[END]";
<br><p align="center"><strong><font size="4">��������� ������������</font></strong></p>
<p><font size="2">������� ������ ���� � �������� ��������� "sendmail" � e-mail
���������� ������. ����� ������� �� ������ "�������", �� ��������� e-mail �����
������� �������� ������.</font></p>
<div align="center"><center>
<form action="/cgi/testsendmail.cgi" method="POST">
<input type="hidden" name="step" value="1">
<table border="0" cellspacing="0">
<tr><td align="right">���� � �������� ���������:</td>
<td><input type="text" name="path" size="20" value="/usr/sbin/sendmail -t"></td></tr>
<tr><td align="right">E-mail ����������:</td>
<td><input type="text" name="email" size="20"></td></tr>
<tr><td></td><td align="right"><input type="submit" value="�������"></td></tr>
</table></form></center></div>
[END]
}
else {
 $out_mail=<<"[END]";
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="Windows-1251"
To: <$FORM{'email'}>
Subject: TestSendmail.


��� ������ ���� ������� �������� �������� "TestSendmail"
 � ����� �������� ����������������� ��������� "sendmail".
[END]
 open(MAIL,"|$FORM{'path'}");
 print MAIL $out_mail;
 close(MAIL);
 if ($! eq '') {
  $out_str=<<"[END]";
<br><p align="center"><strong><font size="4">��������� ������������</font></strong></p>
<p align="center">�������� ������ ������� ����������. ��������� � ����� C:\WebServers\tmp\!sendmail\.</p>
[END]
 }
 else {
  $out_str=<<"[END]";
<br><p align="center"><strong><font size="4">��������� ������������</font></strong></p>
<p align="center">�������� ������ �� �������.<br>������: "$!".</p>
[END]
 }
}

print "Content-type: text/html\n\n";
print << "[END]";
<html>
<head><title>������������ �������� ���������</title></head>
<body>
$out_str
<hr width="100%">
<p align="center"><font size="2">������������ �������� ���������: <a
 href="http://test.ru/cgi/testsendmail.cgi">&quot;TestSendmail&quot;</a><br>
Copyright Denwer � 2011</font></p>
</body>
</html>
[END]

exit;

