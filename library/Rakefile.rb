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

desc "Build all outputs of this project"
task :default => ['bin/libmylib.a']

# Autogenerate rules to compile source files into objects in a parallel hierarchy
# under OBJDIR
SRC.each do |fn|
  # Translate the src path into obj/*/*.o
  obj = fn.pathmap("%{^src,obj}X.o")

  # Add the generated file to the list of objects
  OBJ.include(obj)

  # Define a compile rule to build the object from the source file
  file obj do
    sh "g++ -c -o #{obj} -Iinclude #{fn}"
  end

  # Add OBJDIR as a dependency so it is created before the object
  # compile rule runs
  file obj => OBJDIR
end

desc "Compile sources and output as a static library"
file 'bin/libmylib.a' => [BINDIR] + OBJ do |t|
  sh "ar rcs #{t.name} #{OBJ}"
end

# Manually define object to source/header dependencies
# TODO for larger projects this should use compiler auto dependency generation
# and Rake.import
file 'obj/mylib.o' => ['include/mylib.h', 'src/mylib.cpp']

# Take advantage of rake/clean's automatic clean and clobber rule generation
CLEAN.include(OBJ)
CLOBBER.include([OBJDIR, BINDIR])

