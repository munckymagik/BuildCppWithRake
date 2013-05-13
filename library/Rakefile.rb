require 'rake/clean'

objdir = 'obj'
bindir = 'bin'

directory objdir
directory bindir

SRC = FileList['src/*.cpp']
OBJ = FileList.new() #SRC.pathmap("%{^src,obj}X.o")

task :default => ['bin/libmylib.a']

SRC.each do |fn|
	obj = fn.pathmap("%{^src,obj}X.o")
	OBJ.include(obj)
	file obj do
		sh "g++ -c -o #{obj} -Iinclude #{fn}"
	end

	file obj => objdir
end

file 'bin/libmylib.a' => [OBJ, bindir] do |t|
	sh "ar rcs #{t.name} #{OBJ}"
end

file 'obj/mylib.o' => ['include/mylib.h', 'src/mylib.cpp']

CLEAN.include(OBJ)
CLOBBER.include([objdir, bindir])

