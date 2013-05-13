require 'rake/clean'

# Define outputs folders
OBJDIR = 'obj'
BINDIR = 'bin'

# Instruct Rake to create the output folders
directory OBJDIR
directory BINDIR

# Define the sources in this project
SRC = FileList['src/*.cpp']

# Create an empty FileList that will hold the list of intermediate object files
OBJ = FileList.new()

# Libraries this project depends on
MYLIB = '../library/bin/libmylib.a'

file MYLIB do |t|
  # TODO obviously this suffers from all the problems of recursive make :(
  # See http://stackoverflow.com/questions/4489482/in-rake-how-do-i-call-a-subdir-rakefile
  Dir.chdir('../library') do
    ruby "/usr/local/bin/rake"
  end
end

desc "Build all outputs of this project"
task :default => ['bin/greeter']

# Autogenerate rules to compile source files into objects in a parallel hierarchy
# under OBJDIR
SRC.each do |fn|
  # Translate the src path into obj/*/*.o
  obj = fn.pathmap("%{^src,obj}X.o")

  # Add the generated file to the list of objects
  OBJ.include(obj)

  # Define a compile rule to build the object from the source file
  file obj do
    sh "g++ -c -o #{obj} -I../library/include #{fn}"
  end

  # Add OBJDIR as a dependency so it is created before the object
  # compile rule runs
  file obj => OBJDIR
end

desc "Compile sources and output as an executable binary"
file 'bin/greeter' => [MYLIB, OBJ, BINDIR] do |t|
  sh "g++ -o #{t.name} #{OBJ} #{MYLIB}"
end

# Manually define object to source/header dependencies
# TODO for larger projects this should use compiler auto dependency generation
# and Rake.import
file 'obj/main.o' => ['../library/include/mylib.h']

# Take advantage of rake/clean's automatic clean and clobber rule generation
CLEAN.include(OBJ)
CLOBBER.include([OBJDIR, BINDIR])

