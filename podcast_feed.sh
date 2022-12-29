#!/bin/sh

episodes="$(ls episodes/*.txt | sort -h -r -t '-' -k 3 -k 2 -k 1)"
_last_build_date="$(date -R)"

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<rss xmlns:atom="http://www.w3.org/2005/Atom" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:content="http://purl.org/rss/1.0/modules/content/" version="2.0">
    <channel>
        <title>ցանցառներ ռադիօ</title>
        <link>https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/</link>
        <description>ամէն ինչ տեքի եւ հայաստանի մասին</description>
        <generator>feeder.sh https://feeder.bsd.am</generator>
        <docs>http://blogs.law.harvard.edu/tech/rss</docs>
        <language>hy</language>
        <copyright>Բոլոր իրաւունքները գաղտնալսուած են…</copyright>
        <pubDate>${_last_build_date}</pubDate>
        <lastBuildDate>${_last_build_date}</lastBuildDate>
        <image>
            <url>https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/netters.png</url>
            <title>ցանցառներ ռադիօ</title>
            <link>https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/</link>
        </image>
        <atom:link href="https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/%D5%A4%D6%80%D5%B8%D6%82%D5%A1%D5%A3/%D5%B0%D5%B8%D5%BD%D6%84.xml" rel="self" type="application/rss+xml"/>
        <itunes:author>ցանցառներ</itunes:author>
        <itunes:image href="https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/netters.png"/>
        <itunes:explicit>false</itunes:explicit>
        <itunes:owner>
            <itunes:name>ցանցառներ</itunes:name>
            <itunes:email>antranig@vartanian.am</itunes:email>
        </itunes:owner>
        <itunes:category text="News">
            <itunes:category text="Tech News"/>
        </itunes:category>
        <itunes:type>episodic</itunes:type>
EOF

for episode in ${episodes}
do
  _type="$(grep -E '^TYPE:' ${episode} | sed 's/^TYPE: //' | tr ' ' '_')"
  _type_raw="$(grep -E '^TYPE:' ${episode} | sed 's/^TYPE: //')"
  _type_URIencoded="$(echo ${_type} | python -c 'import urllib.parse; print(urllib.parse.quote(input()))')"

  _num="$(grep -E '^NUM:' ${episode} | sed 's/^NUM: //')"
  _title="$(grep -E '^TITLE:' ${episode} | sed 's/^TITLE: //')"

  _date="$(grep -E '^DATE:' ${episode} | sed 's/^DATE: //')"
  _date_2822="$(date -j -R -f "%d-%m-%Y %H:%M:%S" "${_date} 12:00:00")"

  _video="$(grep -E '^VIDEO:' ${episode} | sed 's/^VIDEO: //')"
  _length="$(curl -sI ${_video} | grep Content-Length | sed -e 's/Content-Length: //' -e 's/\r//')"
  _duration="$(ffprobe ${_video} -show_entries format=duration -of default=nokey=1:noprint_wrappers=1 2>/dev/null | cut -d . -f 1)"

  _guid="$(grep -E '^GUID:' ${episode} | sed 's/^GUID: //')"
  _notes="$(sed -n '/NOTES:/,$ p' ${episode} | xmlstarlet esc)"

  cat <<EOF
        <item>
            <title>${_type_raw} #${_num} – ${_title}</title>
            <link>https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/%D5%A4%D6%80%D5%B8%D6%82%D5%A1%D5%A3/${_type_URIencoded}-${_num}.html</link>
            <description>
${_notes}
</description>
            <pubDate>${_date_2822}</pubDate>
            <enclosure url="${_video}" length="${_length}" type="video/mp4"/>
            <guid isPermaLink="false">${_guid}</guid>
            <itunes:duration>${_duration}</itunes:duration>
            <itunes:episodeType>full</itunes:episodeType>
        </item>
EOF
done

cat <<EOF
    </channel>
</rss>
EOF
