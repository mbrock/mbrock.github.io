#!/bin/sh
cat <<.
<!doctype html>
<meta charset=utf-8>
<style>
body { white-space: pre-wrap; font: 24px georgia, times, serif; margin: 1em; }
em { font-variant: small-caps; text-transform: lowercase; }
</style>
.
curl 'http://hn.algolia.com/api/v1/search_by_date?query=disclaimer&hitsPerPage=20000' |
jq '.hits[] | ._highlightResult.comment_text.value ' |
grep -oE "[[(]?<em>.*</em>: [iI]([ ',-]\([^)]+\)|([ ',-]+(\w)+))+[.)\\]]*" |
sed -r -e "s/^[[(]//" -e "s/(\)|\])$//" |
sort | uniq -i |
while read line; do echo -e "$line\n"; done
cat <<.
<em>disclaimer:</em> I made this list with a <a href=disclaimer.sh>beautiful shell script</a>.
.
