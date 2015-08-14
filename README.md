buffer-complete-OTBEdit
=======================

buffer-complete-OTBEdit is a macro for [OTBEdit](http://www.hi-ho.ne.jp/a_ogawa/otbedit/).
This macro provides completion of using buffer.

Usage
-----

1. current buffer is next

```c
#include <stdio.h>

int main() {
	printf("hello\n");
	p|
}
```

(Cursor is in |)

2. hit `Ctrl+Space`

3. buffer will next

```c
#include <stdio.h>

int main() {
	printf("hello\n");
	printf|
}
```

(Cursor is in |)

Installation
------------

1. download `autoclose-otbedit.zip` from the [releases page](https://github.com/kusabashira/buffer-complete-otbedit/releases)

2. Unpack the zip file, and put all in your `OTBEdit directory`.

3. Write in `otbedit.scm` in `scmlib directory`.

```scm
(use buffer-complete)
```

(Please create if `otbedit.scm` doesn't exist in `scmlib directory`)

Customize
---------

###Change completion key

Write in `otbedit.scm` in `scmlib directory`.

```scm
(define buffer-complete-key <key>)
```

(`<key>` is the key you desire, like "Ctrl+n", "Alt+/")

License
-------

MIT License

Author
------

wara <kusabashira227@gmail.com>
