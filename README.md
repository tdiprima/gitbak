# GitHub Backup

Back up all your repositories.

(I believe I modified backup-github.sh from [this script](https://github.com/tango-controls/GitHubBackup/blob/master/backup-github.sh).  Or you could check [The complete list of every GitHub backup script](https://rewind.com/blog/every-github-backup-script-complete-list/) 😄)

The script has a mechanism to prune old backups based on their age.  It prunes files older than a specified number of days (`GHBU_PRUNE_AFTER_N_DAYS`).

## Usage

Use `./backup-github.sh`

Switch to the correct endpoint for users or organizations:

`GHBU_ORG_TYPE=${GHBU_ORG_TYPE-"users | orgs"}`

Export your github token:

`export GHBU_TOKEN=your_github_token_here`

## SSH Key

It is necessary to set up an SSH key to connect to GitHub.

### See:

* [Connecting To GitHub With SSH](https://help.github.com/articles/connecting-to-github-with-ssh/)
* [Adding a New SSH Key to Your GitHub Account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

<!-- Tammy DiPrima -->
