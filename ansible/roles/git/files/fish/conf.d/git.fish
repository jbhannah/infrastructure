if status is-interactive; and command -sq git
    set -g _git_status_ignore_submodules none

    # Git
    abbr -a -g g git

    # Branch (b)
    abbr -a -g gb git branch
    abbr -a -g gba git branch --all --verbose
    abbr -a -g gbc git checkout -b
    abbr -a -g gbd git branch --delete
    abbr -a -g gbD git branch --delete --force
    abbr -a -g gbl git branch --verbose
    abbr -a -g gbL git branch --all --verbose
    abbr -a -g gbm git branch --move
    abbr -a -g gbM git branch --move --force
    abbr -a -g gbr git branch --move
    abbr -a -g gbR git branch --move --force
    abbr -a -g gbs git show-branch
    abbr -a -g gbS git show-branch --all
    abbr -a -g gbv git branch --verbose
    abbr -a -g gbV git branch --verbose --verbose
    abbr -a -g gbx git branch --delete
    abbr -a -g gbX git branch --delete --force

    # Commit (c)
    abbr -a -g gc git commit --verbose
    abbr -a -g gca git commit --verbose --all
    abbr -a -g gcm git commit --message
    abbr -a -g gcS git commit -S --verbose
    abbr -a -g gcSa git commit -S --verbose --all
    abbr -a -g gcSm git commit -S --message
    abbr -a -g gcam git commit --all --message
    abbr -a -g gco git checkout
    abbr -a -g gcO git checkout --patch
    abbr -a -g gcf git commit --amend --reuse-message HEAD
    abbr -a -g gcSf git commit -S --amend --reuse-message HEAD
    abbr -a -g gcF git commit --verbose --amend
    abbr -a -g gcSF git commit -S --verbose --amend
    abbr -a -g gcp git cherry-pick --ff
    abbr -a -g gcP git cherry-pick --no-commit
    abbr -a -g gcr git revert
    abbr -a -g gcR git reset "HEAD^"
    abbr -a -g gcs git show
    abbr -a -g gcsS git show --pretty=short --show-signature
    abbr -a -g gcl git-commit-lost
    abbr -a -g gcy git cherry -v --abbrev
    abbr -a -g gcY git cherry -v

    # Conflict (C)
    abbr -a -g gCl git --no-pager diff --name-only --diff-filter=U
    abbr -a -g gCa 'git add (gCl)'
    abbr -a -g gCe 'git mergetool (gCl)'
    abbr -a -g gCo git checkout --ours --
    abbr -a -g gCO 'gCo (gCl)'
    abbr -a -g gCt git checkout --theirs --
    abbr -a -g gCT 'gCt (gCl)'

    # Data (d)
    abbr -a -g gd git ls-files
    abbr -a -g gdc git ls-files --cached
    abbr -a -g gdx git ls-files --deleted
    abbr -a -g gdm git ls-files --modified
    abbr -a -g gdu git ls-files --other --exclude-standard
    abbr -a -g gdk git ls-files --killed
    abbr -a -g gdi 'git status --porcelain --short --ignored | sed -n "s/^!! //p"'

    # Fetch (f)
    abbr -a -g gf git fetch
    abbr -a -g gfa git fetch --all
    abbr -a -g gfc git clone
    abbr -a -g gfcr git clone --recurse-submodules
    abbr -a -g gfm git pull
    abbr -a -g gfr git pull --rebase

    # Flow (F)
    abbr -a -g gFi git flow init
    abbr -a -g gFf git flow feature
    abbr -a -g gFb git flow bugfix
    abbr -a -g gFl git flow release
    abbr -a -g gFh git flow hotfix
    abbr -a -g gFs git flow support

    abbr -a -g gFfl git flow feature list
    abbr -a -g gFfs git flow feature start
    abbr -a -g gFff git flow feature finish
    abbr -a -g gFfp git flow feature publish
    abbr -a -g gFft git flow feature track
    abbr -a -g gFfd git flow feature diff
    abbr -a -g gFfr git flow feature rebase
    abbr -a -g gFfc git flow feature checkout
    abbr -a -g gFfm git flow feature pull
    abbr -a -g gFfx git flow feature delete

    abbr -a -g gFbl git flow bugfix list
    abbr -a -g gFbs git flow bugfix start
    abbr -a -g gFbf git flow bugfix finish
    abbr -a -g gFbp git flow bugfix publish
    abbr -a -g gFbt git flow bugfix track
    abbr -a -g gFbd git flow bugfix diff
    abbr -a -g gFbr git flow bugfix rebase
    abbr -a -g gFbc git flow bugfix checkout
    abbr -a -g gFbm git flow bugfix pull
    abbr -a -g gFbx git flow bugfix delete

    abbr -a -g gFll git flow release list
    abbr -a -g gFls git flow release start
    abbr -a -g gFlf git flow release finish
    abbr -a -g gFlp git flow release publish
    abbr -a -g gFlt git flow release track
    abbr -a -g gFld git flow release diff
    abbr -a -g gFlr git flow release rebase
    abbr -a -g gFlc git flow release checkout
    abbr -a -g gFlm git flow release pull
    abbr -a -g gFlx git flow release delete

    abbr -a -g gFhl git flow hotfix list
    abbr -a -g gFhs git flow hotfix start
    abbr -a -g gFhf git flow hotfix finish
    abbr -a -g gFhp git flow hotfix publish
    abbr -a -g gFht git flow hotfix track
    abbr -a -g gFhd git flow hotfix diff
    abbr -a -g gFhr git flow hotfix rebase
    abbr -a -g gFhc git flow hotfix checkout
    abbr -a -g gFhm git flow hotfix pull
    abbr -a -g gFhx git flow hotfix delete

    abbr -a -g gFsl git flow support list
    abbr -a -g gFss git flow support start
    abbr -a -g gFsf git flow support finish
    abbr -a -g gFsp git flow support publish
    abbr -a -g gFst git flow support track
    abbr -a -g gFsd git flow support diff
    abbr -a -g gFsr git flow support rebase
    abbr -a -g gFsc git flow support checkout
    abbr -a -g gFsm git flow support pull
    abbr -a -g gFsx git flow support delete

    # Grep (g)
    abbr -a -g gg git grep
    abbr -a -g ggi git grep --ignore-case
    abbr -a -g ggl git grep --files-with-matches
    abbr -a -g ggL git grep --files-without-matches
    abbr -a -g ggv git grep --invert-match
    abbr -a -g ggw git grep --word-regexp

    # Index (i)
    abbr -a -g gia git add
    abbr -a -g giA git add --patch
    abbr -a -g giu git add --update
    abbr -a -g gid git diff --no-ext-diff --cached
    abbr -a -g giD git diff --no-ext-diff --cached --word-diff
    abbr -a -g gii git update-index --assume-unchanged
    abbr -a -g giI git update-index --no-assume-unchanged
    abbr -a -g gir git reset
    abbr -a -g giR git reset --patch
    abbr -a -g gix git rm -r --cached
    abbr -a -g giX git rm -rf --cached

    # Log (l)
    abbr -a -g gl git log
    abbr -a -g gls git log --stat
    abbr -a -g gld git log --stat --patch --full-diff
    abbr -a -g glo git log --pretty=custom-oneline
    abbr -a -g glg git log --all --graph --pretty=custom-oneline
    abbr -a -g glb git log --pretty=custom-brief
    abbr -a -g glc git shortlog --summary --numbered

    # Merge (m)
    abbr -a -g gm git merge
    abbr -a -g gmC git merge --no-commit
    abbr -a -g gmF git merge --no-ff
    abbr -a -g gma git merge --abort
    abbr -a -g gmt git mergetool

    # Push (p)
    abbr -a -g gp git push
    abbr -a -g gpf git push --force-with-lease
    abbr -a -g gpF git push --force
    abbr -a -g gpa git push --all
    abbr -a -g gpA 'git push --all && git push --tags'
    abbr -a -g gpt git push --tags
    abbr -a -g gpc 'git push --set-upstream origin (__git_branch_current 2> /dev/null)'
    abbr -a -g gpp 'git pull origin (__git_branch_current 2> /dev/null) && git push origin (__git_branch_current 2> /dev/null)'

    # Rebase (r)
    abbr -a -g gr git rebase
    abbr -a -g gra git rebase --abort
    abbr -a -g grc git rebase --continue
    abbr -a -g gri git rebase --interactive
    abbr -a -g grs git rebase --skip

    # Remote (R)
    abbr -a -g gR git remote
    abbr -a -g gRl git remote --verbose
    abbr -a -g gRa git remote add
    abbr -a -g gRx git remote rm
    abbr -a -g gRm git remote rename
    abbr -a -g gRu git remote update
    abbr -a -g gRp git remote prune
    abbr -a -g gRs git remote show
    abbr -a -g gRb git-hub-browse

    # Stash (s)
    abbr -a -g gs git stash
    abbr -a -g gsa git stash apply
    abbr -a -g gsx git stash drop
    abbr -a -g gsX git-stash-clear-interactive
    abbr -a -g gsl git stash list
    abbr -a -g gsL git-stash-dropped
    abbr -a -g gsd git stash show --patch --stat
    abbr -a -g gsp git stash pop
    abbr -a -g gsr git-stash-recover
    abbr -a -g gss git stash save --include-untracked
    abbr -a -g gsS git stash save --patch --no-keep-index
    abbr -a -g gsw git stash save --include-untracked --keep-index

    # Submodule (S)
    abbr -a -g gS git submodule
    abbr -a -g gSa git submodule add
    abbr -a -g gSf git submodule foreach
    abbr -a -g gSi git submodule init
    abbr -a -g gSI git submodule update --init --recursive
    abbr -a -g gSl git submodule status
    abbr -a -g gSm git-submodule-move
    abbr -a -g gSs git submodule sync
    abbr -a -g gSu git submodule update --recursive
    abbr -a -g gSU git submodule foreach git pull origin master
    abbr -a -g gSx git-submodule-remove

    # Tag (t)
    abbr -a -g gt git tag
    abbr -a -g gtl git tag -l
    abbr -a -g gts git tag -s
    abbr -a -g gtv git verify-tag

    # Working Copy (w)
    abbr -a -g gws git status --ignore-submodules=$_git_status_ignore_submodules --short
    abbr -a -g gwS git status --ignore-submodules=$_git_status_ignore_submodules
    abbr -a -g gwd git diff --no-ext-diff
    abbr -a -g gwD git diff --no-ext-diff --word-diff
    abbr -a -g gwr git reset --soft
    abbr -a -g gwR git reset --hard
    abbr -a -g gwc git clean -n
    abbr -a -g gwC git clean -f
    abbr -a -g gwx git rm -r
    abbr -a -g gwX git rm -rf
end
