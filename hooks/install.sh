#!/usr/bin/env bash
#
# install.sh - make git run the checks of hooks/ before every commit, and
# enable the filter of hooks/vitis-paths.sh
#
# Called by 'make hooks' and when a target creates the project (make
# project, or make xsa and the others on a fresh clone). Nothing is copied: the
# pre-commit hook of git calls hooks/vivado_consistency.pre_commit of the
# repository, so a change to the checks applies at the next commit, without
# installing again.
#
# - No pre-commit hook yet, or an old copy of the checks (installed by the
#   first versions of 'make hooks'): one is written that only makes that
#   call.
# - A pre-commit hook written in shell exists: the call is added at its
#   beginning, with a warning. It is added only once.
# - Any other pre-commit hook (Python, ...) is left alone: the call has to
#   be added by hand, and the script says how.

set -euo pipefail

cd "$(dirname "$0")/.."

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not a git repository: git hooks not installed"
    exit 0
fi

# The filter that keeps the absolute path of the product out of the project
# files of sw/vitis/ (see hooks/vitis-paths.sh and .gitattributes).
# git config lives in .git/, so every clone needs it; setting it again
# changes nothing.
git config filter.vitis-paths.clean "bash hooks/vitis-paths.sh clean"
git config filter.vitis-paths.smudge "bash hooks/vitis-paths.sh smudge"
# Files checked out before the filter was enabled, as in a fresh clone,
# still hold @PRODUCT_ROOT@: they are checked out again, now through the
# filter, so that they hold the path of this clone. Otherwise, once Vitis
# writes the real path into them, git status would list them as changed
# with an empty diff. Only files without local changes are touched.
git ls-files -z 'sw/vitis/*.yaml' 'sw/vitis/*.json' 'sw/vitis/*.spr' 'sw/vitis/*.prj' 'sw/vitis/*.sprj' | while IFS= read -r -d '' file; do
    if grep -q -F "@PRODUCT_ROOT@" "$file" && git diff --quiet -- "$file"; then
        rm "$file"
        git checkout -- "$file"
    fi
done

# git rev-parse finds the hooks directory also in a submodule or a worktree,
# where .git is a file.
hooks_dir=$(git rev-parse --git-path hooks)
hook=$hooks_dir/pre-commit
marker="vivado_consistency.pre_commit"
# The text of the hook, written as it is: the $(...) must run when git
# runs the hook, not here.
# shellcheck disable=SC2016
call='# Checks of the Vivado template, added by make hooks: see hooks/ in the repository.
if ! bash "$(git rev-parse --show-toplevel)/hooks/vivado_consistency.pre_commit"; then
    exit 1
fi'

mkdir -p "$hooks_dir"

# The first versions of 'make hooks' copied the checks themselves: replace
# such a copy, which would never be updated.
old_copy="Checks before every commit, with git and shell commands only"
if [ -f "$hook" ] && grep -q -F "$old_copy" "$hook"; then
    rm "$hook"
    echo "Replaced the old copy of the checks in $hook"
fi

if [ ! -f "$hook" ]; then
    printf '#!/usr/bin/env bash\n%s\n' "$call" > "$hook"
    chmod +x "$hook"
    echo "Installed the pre-commit hook in $hook"
    exit 0
fi

if grep -q -F "$marker" "$hook"; then
    echo "The pre-commit hook in $hook already runs the checks of the template"
    exit 0
fi

if ! head -n 1 "$hook" | grep -q -E '^#!.*(ba)?sh'; then
    echo "WARNING: $hook exists and is not a shell script: it was not changed."
    echo "         Make it run this command first, and stop the commit if it fails:"
    echo "         bash \"\$(git rev-parse --show-toplevel)/hooks/vivado_consistency.pre_commit\""
    exit 0
fi

# Keep the shebang as first line, add the call right after it.
{
    head -n 1 "$hook"
    echo "$call"
    tail -n +2 "$hook"
} > "$hook.new"
mv "$hook.new" "$hook"
chmod +x "$hook"
echo "WARNING: $hook already existed: the checks of the template were added at its beginning."
