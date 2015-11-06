#!/bin/sh
cat <<.
<!doctype html>
<meta charset=utf-8>
<style>
body { font: 24px georgia, times, serif; margin: 1em; max-width: 40em; }
em { font-style: normal; }
x { text-transform: lowercase; font-variant: small-caps; }
</style>
.
(for i in 0 1 2 3 4; do
     curl "http://hn.algolia.com/api/v1/search_by_date?query=\"disclaimer:%20i\"&hitsPerPage=200&page=$i"	| jq -r '.hits[] | ._highlightResult.comment_text.value '
 done) |
grep -oE "[[(]?<em>[^<]+</em>([ ',-]\([^)]+\)|([ ',-]+(\w)+))+[.)\\]]*" |
sed -r -e "s/^[[(]//" -e "s/(\)|\])$//" |
sed -e "s/<em>.*disclaimer/<em>disclaimer/i" |
sort |
sed -e "s,disclaimer,<x>disclaimer</x>,i" |
while read line; do echo -e "<p>$line</p>"; done
cat <<.
<em>disclaimer:</em> I made this list with a <a href=disclaimer.sh>beautiful shell script</a>.
.
