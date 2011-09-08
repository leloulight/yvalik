#!/usr/bin/python
# -*- coding: windows-1251 -*-
import string
import sys

words = [ "Hello", "People", "Vassily Poupkinne" ]

print '''Content-type: text/html

<html>

<head>
  <title>Проверка Python</title>
</head>
<body>
Если Вы видите этот текст, значит, Python успешно подгрузил модули string и sys.<br>
Ниже должны идти какие-нибудь слова: <br>
<ul>'''

for word in words:
  print '<li>' + word + '</li>\n'

print '''
</ul>
</body>

</html>
'''



#<!--order=085-->
