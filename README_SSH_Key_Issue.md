The script will ask you for the passphrase for your SSH private key stored at /Users/username/.ssh/id_rsa. This key is used for authenticating with GitHub over SSH.

If you don't know the passphrase for your SSH key and cannot retrieve it, you have two main options: **generate a new SSH key** or **switch to HTTPS authentication**. Here's how to resolve the issue.

---

## Generate a New SSH Key
1. **Create a New Key Pair**:

   ```bash
   ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
   ```

   - When prompted for a passphrase, press `Enter` to leave it blank (not recommended for security) or set a new passphrase you'll remember.

2. **Add the Key to the SSH Agent**:

   ```bash
   eval "$(ssh-agent -s)"       # Start the agent
   ssh-add ~/.ssh/id_rsa        # Add your new key
   ```

3. **Add the Public Key to GitHub**:
   - Copy the public key to your clipboard:

     ```bash
     pbcopy < ~/.ssh/id_rsa.pub  # macOS
     cat ~/.ssh/id_rsa.pub       # Linux, then copy manually
     ```

   - Go to [GitHub SSH settings](https://github.com/settings/keys) and add a new SSH key.

4. **Retry the Script**:
   Your script should now work without prompting for a passphrase.

<br>
