alias c := compile

compile binary:
  crystal build binaries/{{binary}}/source.cr -o binaries/{{binary}}/{{binary}}
  rm binaries/{{binary}}/{{binary}}.dwarf