all: build run

build: 
	ocamlbuild -use-ocamlfind inlecture.d.byte

run: 
	./inlecture.d.byte
	
clean: 
	ocamlbuild -clean
.PHONY: 
	build clean
