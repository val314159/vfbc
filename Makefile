C=c/
B=$C-1/-1/block.txt
D=$C-1/-1/nxt/
call: clean all
all: c
	ros demo.lisp
#	c/-1/-1/nxt/launch.ros
c:
	mkdir -p $D
	touch $B
	cp -rp launch.ros $D
	cp -rp v*-*.lisp  $D
	cp -rp static/    $C/static/
	tree -sFl $C
clean:
	rm -fr ? *~
	tree -sFl .
