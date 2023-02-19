#!/bin/sh

episodes="$(ls episodes/*.txt | sort -h -r -t '-' -k 3 -k 2 -k 1)"

cat <<EOF
<?xml version="1.0"?>
<opml version="2.0">
	<head>
		<title>թողարկումներ</title>
		<dateCreated>Sun, 25 Dec 2022 23:32:45 GMT</dateCreated>
		<ownerEmail>antranig@vartanian.am</ownerEmail>
		<additionalHead>&lt;link rel=&quot;alternate&quot; type=&quot;application/rss+xml&quot; title=&quot;Podcast RSS feed&quot; href=&quot;/թողարկում/հոսք.xml&quot; /&gt;</additionalHead>
		<license>CC BY 4.0</license>
		<copyleft>Բոլոր իրաւունքները գաղտնալսուած են…</copyleft>
		<logo>/netters.png</logo>
		<ownerName>Antranig Vartanian</ownerName>
		<ownerId>http://twitter.com/undefined</ownerId>
		<urlUpdateSocket>ws://drummer.scripting.com:1232/</urlUpdateSocket>
		<dateModified>Mon, 26 Dec 2022 01:11:01 GMT</dateModified>
		<expansionState>1,3</expansionState>
		<lastCursor>3</lastCursor>
		</head>
	<body>
		<outline text="ցանցառներ ռադիօ" created="Sun, 25 Dec 2022 23:32:45 GMT">
			<outline text="վերադառնալ  գլխաւոր էջ" created="Sun, 25 Dec 2022 23:33:55 GMT" type="link" url="https://ռադիօ.ցանցառներ.հայ/"/>
			</outline>
		<outline text="թողարկումներ" created="Sun, 25 Dec 2022 23:35:18 GMT">
EOF

for episode in ${episodes}
do
  ./episode.sh ${episode}
  _type="$(grep -E '^TYPE:' ${episode} | sed 's/^TYPE: //' | tr ' ' '_')"
  _num="$(grep -E '^NUM:' ${episode} | sed 's/^NUM: //')"
  _title="$(grep -E '^TITLE:' ${episode} | sed 's/^TITLE: //')"
  cat <<EOF
<outline text="${_type} #${_num} - ${_title}" type="link" url="${_type}-${_num}.html"/>"
EOF
done

cat <<EOF
			</outline>
		</body>
	</opml>
EOF
