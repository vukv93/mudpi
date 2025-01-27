---
title: 'Nouua'
subtitle: 'Arcane notebook system'
...

![Nouua](doc/images/nouua.svg){width=256px}

## Scope

A story and a template to make it.

## References

- [bookmarks](bookmark.html) @ext
- [mudpi](mudpi.html)
- [garage](garage.html)
- @ext [gruvbox-contrib](https://github.com/morhetz/gruvbox-contrib)
- [cover](index.html)
- @ext [nouua.com](https://nouua.com)

## Implementation

### A code example

~~~{.sh}
cat <<EOF > tmp.cpp && g++ tmp.cpp && ./a.out && rm tmp.cpp a.out
~~~
~~~{.cpp}
#include <chrono>
#include <iostream>
#include <iomanip>
using namespace std;
using sc = chrono::system_clock;
int main(int, char**) {
  auto t = sc::to_time_t(sc::now());
  cout << put_time(localtime(&t),"%y%m%d_%H%M%S") << endl;
}
~~~
~~~{.sh}
EOF
# ||
date +%y%m%d_%H%M%S
~~~

### 250127_012408 @todo Markdown bootstrap

## Discussion

### 250127_003910 Test post

![Test](doc/images/test.svg){width=256px}

### 250116_210317 @todo Initial republish @done 250125_072327
- [x] Prepare release
    - [x] Containerfile
    - [x] Makefile
    - [x] Notebook
    - [x] Other
    - [x] Final touches
- [x] Push to GitHub
- [x] Publish on nouua

### 250124_054444 @ongoing Update references
### 250124_060945 @todo Test lldb
### 250124_060723 @todo GitHub markdown compliance
### 250125_183935 @todo Fix HTML code block font size inconsistency

