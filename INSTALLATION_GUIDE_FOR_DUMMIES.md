# Installation Guide for Dummies 🛠️

**Don't panic!** This guide will walk you through installing the API documentation on your computer, step by step. We'll explain everything like you're five years old.

---

## 🤔 Why Would I Want to Install This?

**Good question!** You can just read the docs online at [api.audiobookshelf.org](https://api.audiobookshelf.org).

**But you should install it locally if:**
- You want to edit/improve the documentation
- You want to work offline (no internet needed)
- You want to see your changes before sharing them
- You're contributing to the project

**If you just want to READ the docs:** Go to [api.audiobookshelf.org](https://api.audiobookshelf.org) and skip this guide!

---

## 🖥️ What You'll Need

### Your Computer Must Have:
- **Windows 10/11**, **macOS 10.14+**, or **Linux** (Ubuntu, Debian, etc.)
- At least **2 GB of free disk space**
- Internet connection (just for installation)
- About **30 minutes** of your time

### You'll Install These Tools:
Don't worry! We'll show you how.
- **Git** (tool for downloading code)
- **Ruby** (programming language that runs the docs)
- **Bundler** (tool that installs Ruby stuff)

---

## 📋 Choose Your Operating System

Click the one you have:
- [Windows](#windows-installation)
- [macOS](#macos-installation)
- [Linux (Ubuntu/Debian)](#linux-installation)

---

## 🪟 Windows Installation

### Step 1: Install Git

**What is Git?** It's a tool for downloading and managing code.

1. **Download Git:**
   - Go to: https://git-scm.com/download/win
   - Click the download link (it should start automatically)
   - Wait for the file to download (about 50 MB)

2. **Install Git:**
   - Find the downloaded file (probably in your Downloads folder)
   - Double-click `Git-2.xx.x-64-bit.exe`
   - Click "Next" through all the screens (the defaults are fine)
   - Wait for it to install (takes about 2 minutes)
   - Click "Finish"

3. **Check if it worked:**
   - Press `Windows Key + R`
   - Type `cmd` and press Enter
   - A black window appears (this is the "Command Prompt")
   - Type: `git --version`
   - Press Enter
   - You should see something like `git version 2.43.0`
   - If you see an error, restart your computer and try again

### Step 2: Install Ruby

**What is Ruby?** It's a programming language. The documentation runs on Ruby.

1. **Download Ruby:**
   - Go to: https://rubyinstaller.org/downloads/
   - Download **Ruby+Devkit 3.3.6 (x64)** (the big red button)
   - Wait for download (about 100 MB)

2. **Install Ruby:**
   - Find the downloaded file
   - Double-click `rubyinstaller-devkit-3.3.6-1-x64.exe`
   - Check the box "Add Ruby to PATH"
   - Click "Next" through the screens
   - When it asks about MSYS2, choose option 3 (MSYS2 and MINGW)
   - Let it install (takes about 5 minutes)
   - When the black window appears with options 1, 2, 3:
     - Type `3` and press Enter
     - Wait for it to finish (lots of text will scroll by)
     - Press Enter to close the window
   - Click "Finish"

3. **Check if it worked:**
   - Open a **NEW** Command Prompt (close the old one first!)
   - Type: `ruby --version`
   - You should see something like `ruby 3.3.6`
   - Type: `gem --version`
   - You should see something like `3.5.0`

### Step 3: Install Bundler

**What is Bundler?** It installs all the Ruby stuff the docs need.

1. **In the Command Prompt, type:**
   ```
   gem install bundler
   ```

2. **Press Enter and wait** (takes 10-30 seconds)

3. **Check if it worked:**
   ```
   bundle --version
   ```
   Should show something like `Bundler version 2.5.0`

### Step 4: Download the Documentation

1. **Create a folder for your projects:**
   - Open File Explorer
   - Go to `C:\Users\YourName\`
   - Right-click → New → Folder
   - Name it `Projects`

2. **Open Command Prompt in that folder:**
   - Open the `Projects` folder
   - In the address bar at the top, type `cmd` and press Enter
   - A Command Prompt opens in that folder

3. **Download the docs:**
   ```
   git clone https://github.com/AlmightyTopher/audiobookshelf-api-docs.git
   ```
   (This downloads all the files - takes 1-2 minutes)

4. **Go into the folder:**
   ```
   cd audiobookshelf-api-docs
   ```

### Step 5: Install Documentation Dependencies

**What are dependencies?** Extra code the documentation needs to run.

1. **In the Command Prompt (still in the audiobookshelf-api-docs folder), type:**
   ```
   bundle install
   ```

2. **Press Enter and wait** (takes 2-5 minutes)
   - You'll see lots of text scrolling by
   - It's downloading and installing about 50 small programs
   - When it says "Bundle complete!" you're done!

### Step 6: Run the Documentation!

1. **Start the documentation server:**
   ```
   bundle exec middleman server
   ```

2. **Wait for it to start** (takes 10-30 seconds)
   - You'll see text appear
   - When you see `View your site at "http://0.0.0.0:4567"`, it's ready!

3. **Open your web browser:**
   - Open Chrome, Firefox, Edge, or any browser
   - Go to: `http://localhost:4567`
   - **You should see the API documentation!** 🎉

4. **To stop the server later:**
   - Go back to the Command Prompt
   - Press `Ctrl + C`
   - Type `Y` and press Enter

### 🎉 Success! (Windows)

You did it! The documentation is running on your computer.

**What now?**
- Edit files in `C:\Users\YourName\Projects\audiobookshelf-api-docs\source\includes\`
- Refresh your browser to see changes
- Read the main README.md for contribution guidelines

---

## 🍎 macOS Installation

### Step 1: Install Homebrew

**What is Homebrew?** It's like an app store for command-line tools.

1. **Open Terminal:**
   - Press `Cmd + Space`
   - Type `terminal`
   - Press Enter
   - A white or black window appears

2. **Install Homebrew:**
   - Copy this entire command:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
   - Paste it into Terminal
   - Press Enter
   - It will ask for your password (the one you use to log into your Mac)
   - Type your password (you won't see it appear - that's normal!)
   - Press Enter
   - Press Enter again when it asks you to
   - Wait 5-10 minutes while it installs

3. **Check if it worked:**
   ```bash
   brew --version
   ```
   Should show something like `Homebrew 4.2.0`

### Step 2: Install Git and Ruby

**Good news!** macOS comes with Git pre-installed, but we'll get the latest version.

1. **Install Git:**
   ```bash
   brew install git
   ```
   Wait 1-2 minutes.

2. **Install Ruby:**
   ```bash
   brew install ruby@3.3
   ```
   Wait 2-5 minutes.

3. **Add Ruby to your PATH:**
   - Check which shell you're using:
   ```bash
   echo $SHELL
   ```

   - If it says `/bin/zsh`:
   ```bash
   echo 'export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

   - If it says `/bin/bash`:
   ```bash
   echo 'export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"' >> ~/.bash_profile
   source ~/.bash_profile
   ```

4. **Check if it worked:**
   ```bash
   ruby --version
   ```
   Should show `ruby 3.3.x`

### Step 3: Install Bundler

```bash
gem install bundler
```

Wait 10-30 seconds.

### Step 4: Download the Documentation

1. **Create a folder for projects:**
   ```bash
   mkdir -p ~/Projects
   cd ~/Projects
   ```

2. **Download the docs:**
   ```bash
   git clone https://github.com/AlmightyTopher/audiobookshelf-api-docs.git
   cd audiobookshelf-api-docs
   ```

### Step 5: Install Dependencies

```bash
bundle install
```

Wait 2-5 minutes while it downloads everything.

### Step 6: Run the Documentation!

1. **Start the server:**
   ```bash
   bundle exec middleman server
   ```

2. **Open your browser:**
   - Go to: `http://localhost:4567`
   - **You should see the docs!** 🎉

3. **To stop later:**
   - Press `Ctrl + C` in Terminal

### 🎉 Success! (macOS)

You're all set!

**Files are located at:** `~/Projects/audiobookshelf-api-docs/`

---

## 🐧 Linux Installation

### For Ubuntu/Debian

### Step 1: Install Git and Ruby

1. **Open Terminal** (Ctrl + Alt + T)

2. **Update your package list:**
   ```bash
   sudo apt update
   ```
   Enter your password when asked.

3. **Install Git:**
   ```bash
   sudo apt install git
   ```
   Type `Y` and press Enter when asked.

4. **Install Ruby:**
   ```bash
   sudo apt install ruby-full ruby-dev build-essential
   ```
   Type `Y` and press Enter.

5. **Check versions:**
   ```bash
   git --version
   ruby --version
   ```

### Step 2: Install Bundler

```bash
gem install bundler --user-install
```

**Add gems to PATH:**
```bash
echo 'export PATH="$HOME/.local/share/gem/ruby/3.x.x/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```
(Replace 3.x.x with your Ruby version)

### Step 3: Download the Documentation

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/AlmightyTopher/audiobookshelf-api-docs.git
cd audiobookshelf-api-docs
```

### Step 4: Install Dependencies

```bash
bundle install
```

### Step 5: Run the Documentation

```bash
bundle exec middleman server
```

Open browser to `http://localhost:4567`

### 🎉 Success! (Linux)

All set! Files are at `~/Projects/audiobookshelf-api-docs/`

---

## 🆘 Troubleshooting

### "Command not found" error

**Problem:** Terminal/Command Prompt doesn't recognize a command.

**Solutions:**
1. Close and reopen Terminal/Command Prompt
2. Restart your computer
3. Check that you installed the tool correctly
4. Make sure you added it to PATH (especially on Windows)

### "Permission denied" error

**On Windows:**
- Right-click Command Prompt
- Choose "Run as Administrator"
- Try again

**On Mac/Linux:**
- Some commands need `sudo` at the start
- Example: `sudo gem install bundler`
- Enter your password when asked

### "Bundle install" fails

**Common causes:**

1. **Missing build tools:**
   - Windows: Install Visual Studio Build Tools
   - Mac: Run `xcode-select --install`
   - Linux: Run `sudo apt install build-essential`

2. **Old Ruby version:**
   - Need Ruby 3.0 or newer
   - Check: `ruby --version`
   - Uninstall old version and reinstall

3. **Network issues:**
   - Check internet connection
   - Try again in a few minutes
   - Some firewalls block gem downloads

### "Port already in use" error

**Problem:** Something else is using port 4567.

**Solution:**
- Stop the other program
- Or use a different port:
  ```bash
  bundle exec middleman server -p 8080
  ```
  Then open `http://localhost:8080`

### Server starts but browser shows error

**Check:**
1. Are you going to `http://localhost:4567` (not `https`)?
2. Did you wait for "View your site at..." message?
3. Try a different browser
4. Try `http://127.0.0.1:4567` instead

### Changes don't show up

**Solutions:**
1. Refresh browser (Ctrl+R or Cmd+R)
2. Hard refresh (Ctrl+Shift+R or Cmd+Shift+R)
3. Clear browser cache
4. Restart the middleman server

---

## 🎓 What Next?

### Editing the Documentation

**Files are organized like this:**
```
audiobookshelf-api-docs/
├── source/
│   ├── includes/           ← Edit these files!
│   │   ├── _libraries.md   ← Libraries section
│   │   ├── _users.md       ← Users section
│   │   └── ...
│   └── index.html.md       ← Main page config
```

**To edit:**
1. Open any `.md` file in a text editor
2. Make your changes
3. Save the file
4. Refresh your browser
5. See your changes instantly!

### Building for Production

**When you're done editing:**

```bash
bundle exec middleman build
```

This creates a `build/` folder with static HTML files.

### Generating a PDF

```bash
# First, install wkhtmltopdf:

# Windows: Download from https://wkhtmltopdf.org/downloads.html
# Mac: brew install wkhtmltopdf
# Linux: sudo apt install wkhtmltopdf

# Then run:
./generate-pdf.sh
```

PDF will be in `build/downloads/`

---

## 📞 Still Stuck?

### Get Help:

1. **Search existing issues:**
   https://github.com/AlmightyTopher/audiobookshelf-api-docs/issues

2. **Ask on Discord:**
   https://discord.gg/audiobookshelf

3. **Open a new issue:**
   https://github.com/AlmightyTopher/audiobookshelf-api-docs/issues/new
   - Describe your problem
   - Include error messages
   - Say what OS you're using
   - Say what you tried

### Before asking for help:

✅ **Do this:**
- Copy the exact error message
- List the steps you took
- Say what you expected vs. what happened
- Check if others had the same issue

❌ **Don't do this:**
- Say "it doesn't work" (too vague!)
- Skip steps in this guide
- Get frustrated (we're here to help!)

---

## 🎊 Congratulations!

You've successfully installed the API documentation!

**You can now:**
- ✅ View the docs offline
- ✅ Edit and improve the docs
- ✅ See changes in real-time
- ✅ Build static HTML
- ✅ Generate PDFs

**What now?**
- Read [README_FOR_DUMMIES.md](README_FOR_DUMMIES.md) to understand the docs
- Read [README.md](README.md) for contribution guidelines
- Check out [QUICK_START_EXAMPLES.md](QUICK_START_EXAMPLES.md) for code examples

**Happy documenting! 📚**

---

## 🔖 Quick Reference

### Start the server:
```bash
cd ~/Projects/audiobookshelf-api-docs   # Mac/Linux
cd C:\Users\YourName\Projects\audiobookshelf-api-docs  # Windows

bundle exec middleman server
```

### Build static files:
```bash
bundle exec middleman build
```

### Generate PDF:
```bash
./generate-pdf.sh
```

### Update to latest version:
```bash
git pull origin main
bundle install
```

### Stop the server:
Press `Ctrl + C`

---

**Questions? Problems? Suggestions?**
Open an issue: https://github.com/AlmightyTopher/audiobookshelf-api-docs/issues

**Built with ❤️ by the Audiobookshelf community**
