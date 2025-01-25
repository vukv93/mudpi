fout=$1
mkdir -p build
rm -rf $fout && touch $fout
cat <<EOF >> $fout
---
title: '$(pwd)'
subtitle: 'Tracked files'
...
EOF
for f in $(git ls-files); do
  echo "## $f" >> $fout
  fbn=$(basename "$f")
  echo "~~~~~~~~{.${fbn##*.}}" >> $fout
  cat $f >> $fout
  echo >> $fout
  echo "~~~~~~~~~~~~~~~~~~" >> $fout
  echo >> $fout
done
