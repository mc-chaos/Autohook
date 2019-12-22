#! /bin/bash

# set colors
c_fail='1'  # red
c_pass='2'  # green

function header() { tput bold; echo -e "\n${1}"; tput sgr0; }
function fail() { tput setaf $c_fail; echo -ne "${1}"; tput sgr0; }
function pass() { tput setaf $c_pass; echo -ne "${1}"; tput sgr0; }

# validating the whole manifest takes too long. uncomment this
# if you want to test the whole shebang.
# for file in $(find . -name "*.sh")
#   for file in $(git diff --name-only --cached | grep -E '\.(sh)')
for file in $(git diff --name-only --cached | grep -E '\.(dockerfile|Dockerfile)'); do
  if [[ -f $file ]]; then
    if docker run --rm -i hadolint/hadolint < "$file"
    then
      fail "FAILED: "; echo "$file"
      syntax_is_bad=1
    else
      pass "PASSED: "; echo "$file"
    fi
  fi
done


if [[ $syntax_is_bad -eq 1 ]]; then
  fail "\nErrors Found, Commit REJECTED\n"
  exit 1
else
  pass "\nNo Errors Found, Commit ACCEPTED\n"
fi
