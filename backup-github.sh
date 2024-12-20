#!/usr/bin/env bash
# A simple script to backup an organization's GitHub repositories.

# set -euo pipefail # error handling

dir_tstamp=$(date +%Y-%m-%d_%H-%M-%S)
GHBU_BACKUP_DIR=${dir_tstamp}                                        # where to place the backup files
# TODO: Switch to the correct endpoint for users or organizations
# GHBU_ORG_TYPE=${GHBU_ORG_TYPE-"orgs"}                              # are you doing an organization or a user (orgs | users)
GHBU_ORG_TYPE="users"
GHBU_ORG=${GHBU_ORG-""}                                              # the GitHub organization (or GitHub username) whose repos will be backed up
# TODO: export GHBU_TOKEN=your_github_token_here
# GHBU_TOKEN=${GHBU_TOKEN-""}                                        # GitHub Personal Access Token
GHBU_GITHOST=${GHBU_GITHOST-"github.com"}                            # the GitHub hostname (see notes)
GHBU_PRUNE_OLD=${GHBU_PRUNE_OLD-true}                                # when `true`, old backups will be deleted
GHBU_PRUNE_AFTER_N_DAYS=${GHBU_PRUNE_AFTER_N_DAYS-3}                 # the min age (in days) of backup files to delete
GHBU_SILENT=${GHBU_SILENT-false}                                     # when `true`, only show error messages
GHBU_API=${GHBU_API-"https://api.github.com"}                        # base URI for the GitHub API
GHBU_GIT_CLONE_CMD="git clone --quiet --mirror git@${GHBU_GITHOST}:" # base command to use to clone GitHub repos

# time stamp the files
TSTAMP=$(date "+%Y%m%d-%H%M")

# The function `check` will exit the script if the given command fails.
function check {
  "$@"
  status=$?
  if [ $status -ne 0 ]; then
    echo "ERROR: Encountered error (${status}) while running the following:" >&2
    echo "           $*"  >&2
    echo "       (at line ${BASH_LINENO[0]} of file $0.)"  >&2
    echo "       Aborting." >&2
    exit $status
  fi
}

# The function `tgz` will create a gzipped tar archive of the specified file ($1) and then remove the original
# the option -P omits the error message tar: Removing leading '/' from member names
function tgz {
   check tar zcPf "$1.tar.gz" "$1" && check rm -rf "$1"
}

echo "-------------"
echo "Date: $(date)"
echo "-------------"

$GHBU_SILENT || (echo "" && echo "=== INITIALIZING ===" && echo "")

$GHBU_SILENT || echo "Using backup directory $GHBU_BACKUP_DIR"
check mkdir -p "$GHBU_BACKUP_DIR"

$GHBU_SILENT || echo "Fetching list of repositories for ${GHBU_ORG}..."
# If you have more than 100 repositories, you'll need to step thru the list of repos
# returned by GitHub one page at a time.
# Cycling through pages:
PAGE=0
REPOLIST=""
while true; do
  let PAGE++
  $GHBU_SILENT || echo "getting page ${PAGE}"
  REPOLIST_TMP=$(check curl --silent -H "Authorization: token $GHBU_TOKEN" \
    "${GHBU_API}/${GHBU_ORG_TYPE}/${GHBU_ORG}/repos?page=${PAGE}&per_page=90" \
    | jq -r '.[].name')
  if [ -z "$REPOLIST_TMP" ]; then break; fi
  REPOLIST="${REPOLIST} ${REPOLIST_TMP}"
done

list_count=$(echo "$REPOLIST" | wc -w)
list_count="$(echo -e "${list_count}" | tr -d '[:space:]')"
$GHBU_SILENT || echo "found $list_count repositories."

$GHBU_SILENT || (echo "" && echo "=== BACKING UP ===" && echo "")

# If you just want one, uncomment this line:
#REPOLIST="your-repo"
COUNT=0
for REPO in $REPOLIST; do
   let COUNT++
   current_repo=${REPO}
   echo
   echo "#$COUNT of $list_count: $current_repo"
   echo

   $GHBU_SILENT || echo "Backing up ${GHBU_ORG}/${REPO}"
   # check ${GHBU_GIT_CLONE_CMD}${GHBU_ORG}/${REPO}.git ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}-${TSTAMP}.git && tgz ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}-${TSTAMP}.git
   ${GHBU_GIT_CLONE_CMD}${GHBU_ORG}/${REPO}.git ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}-${TSTAMP}.git && tgz ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}-${TSTAMP}.git || continue
   sleep 5

   $GHBU_SILENT || echo "Backing up ${GHBU_ORG}/${REPO}.wiki (if any)"
   ${GHBU_GIT_CLONE_CMD}${GHBU_ORG}/${REPO}.wiki.git ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}.wiki-${TSTAMP}.git 2>/dev/null && tgz ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}.wiki-${TSTAMP}.git
   sleep 5

   $GHBU_SILENT || echo "Backing up ${GHBU_ORG}/${REPO} issues"
   check curl --silent -H "Authorization: token $GHBU_TOKEN" \
    "${GHBU_API}/repos/${GHBU_ORG}/${REPO}/issues" -q > ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}.issues-${TSTAMP}.json && tgz ${GHBU_BACKUP_DIR}/${GHBU_ORG}-${REPO}.issues-${TSTAMP}.json
   sleep 5
done

if $GHBU_PRUNE_OLD; then
  $GHBU_SILENT || (echo "" && echo "=== PRUNING ===" && echo "")
  $GHBU_SILENT || echo "Pruning backup files ${GHBU_PRUNE_AFTER_N_DAYS} days old or older."
  $GHBU_SILENT || echo "Found $(find "$GHBU_BACKUP_DIR" -name '*.tar.gz' -mtime +"$GHBU_PRUNE_AFTER_N_DAYS" | wc -l) files to prune."
  find "$GHBU_BACKUP_DIR" -name '*.tar.gz' -mtime +"$GHBU_PRUNE_AFTER_N_DAYS" -exec rm -fv {} > /dev/null \;
fi

$GHBU_SILENT || (echo "" && echo "=== DONE ===" && echo "")
$GHBU_SILENT || (echo "GitHub backup completed." && echo "")

#a=$(pwd)
#"$a/prt_list.sh" "$dir_tstamp"

echo "-------------"
echo "Date: $(date)"
echo "-------------"
