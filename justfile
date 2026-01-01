alias c := compile
alias co := commit

compile binary:
  crystal build binaries/{{binary}}/source.cr -o binaries/{{binary}}/{{binary}}
  rm binaries/{{binary}}/{{binary}}.dwarf

commit binary:
  git add binaries/{{binary}}
  git commit -m "feat: add '{{binary}}' binary"
  git push