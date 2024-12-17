# GitHub Backup

Back up all your repositories.

(I believe I modified it from this one: https://github.com/tango-controls/GitHubBackup/blob/master/backup-github.sh.  Or you could check [The complete list of every GitHub backup script](https://rewind.com/blog/every-github-backup-script-complete-list/) 😄)

Keep the three most current, pop off the oldest.

## Usage

Use `backup-github.sh` and change `GHBU_UNAME` to your GitHub username, `GHBU_PASSWD` to your password, and `GHBU_ORG` to your organization.

_I'm assuming now you'd have to use an API key instead of username/password._

## SSH Key

It is necessary to set up an SSH key to connect to GitHub.

### See:

* [Connecting To GitHub With SSH](https://help.github.com/articles/connecting-to-github-with-ssh/)
* [Adding a New SSH Key to Your GitHub Account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

<!-- Tammy DiPrima -->
