#!/usr/bin/python
# -*- coding: windows-1251 -*-
import string
import sys

words = [ "Hello", "People", "Vassily Poupkinne" ]

print '''Content-type: text/html

<html>

<head>
  <title>�������� Python</title>
</head>
<body>
���� �� ������ ���� �����, ������, Python ������� ��������� ������ string � sys.<br>
���� ������ ���� �����-������ �����: <br>
<ul>'''

for word in words:
  print '<li>' + word + '</li>\n'

print '''
</ul>
</body>

</html>
'''



#<!--order=085-->
