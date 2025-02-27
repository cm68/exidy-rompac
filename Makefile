STLS= rompac-b.stl rompac-t.stl
all: $(STLS)

clobber: clean
	rm -f $(STLS)

clean:
	rm -f *.fpp

rompac-b.stl: rompac.scad
	openscad -o rompac-b.stl -D 'express="b"' rompac.scad

rompac-t.stl: rompac.scad
	openscad -o rompac-t.stl -D 'express="t"' rompac.scad

