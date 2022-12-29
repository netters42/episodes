#!/bin/sh

episode="${1}"

_type="$(grep -E '^TYPE:' ${episode} | sed 's/^TYPE: //' | tr ' ' '_')"
_type_raw="$(grep -E '^TYPE:' ${episode} | sed 's/^TYPE: //')"

_num="$(grep -E '^NUM:' ${episode} | sed 's/^NUM: //')"
_title="$(grep -E '^TITLE:' ${episode} | sed 's/^TITLE: //')"

_video="$(grep -E '^VIDEO:' ${episode} | sed 's/^VIDEO: //')"

_date="$(grep -E '^DATE:' ${episode} | sed 's/^DATE: //')"

_notes="$(sed -n '/NOTES:/,$ p' ${episode} | sed -e '/^$/d' -e 's/^/<p>/' -e 's/$/<\/p>\n/')"

cat <<EOF > public/${_type}-${_num}.html
<?xml version="1.0"?>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/">
  <head>
    <title>#${_num} – ${_title}</title>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
    <meta name="HandheldFriendly" content="True" />
    <meta name="MobileOptimized" content="320" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="oblox.css" />
    <link rel="alternate" type="application/rss+xml" title="Podcast RSS feed" href="/ցանցառներ_ռադիօ.xml" />
  </head>
  <body>
    <h1>
      <span class="at">${_type_raw} #${_num}</span>
    </h1>
    <img src="/logo.png" width="96" style="margin: auto; display: block;" />
    <fieldset>
      <legend>↩</legend>
      <ul>
        <li style="padding-bottom: 5px;">
          <a href="https://xn--y9agv9d4b.xn--y9aam0eb9a4abc.xn--y9a3aq/թողարկում/">վերադառնալ գլխաւոր էջ</a>
        </li>
      </ul>
    </fieldset>
    <fieldset>
      <legend>#${_num}</legend>
      <ul>
        <li style="padding-bottom: 5px;">${_title}</li>
        <li style="padding-bottom: 5px;">վերբեռնուած է ${_date}</li>
      </ul>
    </fieldset>
    <fieldset>
      <legend id="video">տեսանիւթ</legend>
      <video src="${_video}" controls></video>
    </fieldset>
    <fieldset id="notes">
      <legend>նշումներ</legend>
${_notes}
    </fieldset>
    <p class="footer">CC BY 4.0 | Բոլոր իրաւունքները գաղտնալսուած են…</p>
    <div>
      <p style="float: right; font-size: 10px;">
        <a href="https://oblox.bsd.am/">Made with oblox</a>
      </p>
    </div>
    <script>
      function setVideoTime(p) {
         [h, m, s] = p.split(':')
         ts = (h * 3600) + (m * 60) + (s * 1)
         video = document.getElementsByTagName('video')[0]
         video.currentTime = ts
      }

      function checkTs(p) {
        if (p.innerHTML.search(/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9] /) === 0) {
          p.innerHTML = p.innerHTML.replace(/^[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/, '<a href="#video" onclick="setVideoTime(this.innerHTML)">$&</a>')
        }
      }

      notes = document.getElementById('notes')
      notes.childNodes.forEach(element =>
        element.nodeName === "P" ? checkTs(element) : null
      )
    </script>
  </body>
</html>
EOF
