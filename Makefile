C=c/
B=$C-1/-1/block.txt
D=$C-1/-1/nxt/
E=$C-1/-1/xtn/
call: clean all
all: c
c:
	mkdir -p $D $E
	touch $B
	cp -rp launch.ros $D
	cp -rp v*-*.lisp  $D
	cp -rp static/    $C/static/
	tree -sFl c
clean:
	rm -fr ? *~
	tree -sFl .
