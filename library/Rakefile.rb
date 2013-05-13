CLEAN = FileList['obj/*.o']
CLOBBER = FileList['bin/*']


task :default => ['obj/mylib.o']


file 'obj/mylib.o' => ['src/mylib.cpp'] do
	sh "g++ -c -o obj/mylib.o -Iinclude src/mylib.cpp"
end

