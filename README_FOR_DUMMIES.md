# README for Dummies 🎓

**Welcome!** You've found the Audiobookshelf API Documentation. Don't worry if you're not sure what that means - we'll explain everything!

---

## 🤔 What Is This?

Think of this like a **instruction manual** for programmers who want to build apps that talk to Audiobookshelf.

**What's Audiobookshelf?**
It's a free app that lets you organize and listen to audiobooks and podcasts on your own computer (instead of using something like Audible).

**What's an API?**
API stands for "Application Programming Interface." It's like a waiter at a restaurant:
- You (the app) tell the waiter (API) what you want
- The waiter tells the kitchen (Audiobookshelf server)
- The kitchen makes your order
- The waiter brings it back to you

**What's this documentation for?**
It tells programmers exactly how to "order from the menu" - what requests they can make and what they'll get back.

---

## 🎯 Who Is This For?

### ✅ You SHOULD use this if you want to:
- Build your own Audiobookshelf app
- Make a mobile app that connects to your Audiobookshelf server
- Create automation scripts (like "automatically mark books as read")
- Integrate Audiobookshelf with other software
- Learn how APIs work by studying examples

### ❌ You DON'T need this if you:
- Just want to use Audiobookshelf normally (use the regular app instead!)
- Don't know how to code at all (learn programming basics first)
- Only want to listen to audiobooks (just download the Audiobookshelf app)

---

## 📚 What's Inside This Documentation?

### 1. **Quick Start Guide**
Think of this as "How to make your first API call in 5 minutes"
- Shows you how to log in
- Get your list of audiobooks
- Simple copy-paste examples

### 2. **Endpoint Matrix**
A giant table showing all 135 things you can do:
- Get libraries
- Play audiobooks
- Track your progress
- Share books with friends
- And 131 more!

### 3. **Code Examples**
Real, working code you can copy and paste in:
- **Bash** (command line)
- **JavaScript** (for web developers)
- **Python** (popular programming language)

### 4. **API Coverage Report**
Shows which parts are documented (97.8% - almost everything!)

---

## 🚀 Getting Started (Super Simple Version)

### Step 1: Do You Have Audiobookshelf Running?

**Before you can use the API, you need:**
- Audiobookshelf installed and running on a computer
- The web address of your server (like `http://192.168.1.100:13378`)
- A username and password

**Don't have this yet?**
1. Go to [audiobookshelf.org](https://www.audiobookshelf.org/)
2. Follow their installation guide
3. Set up your first library
4. Come back here!

### Step 2: View the Documentation

**Online (easiest):**
Just visit: [api.audiobookshelf.org](https://api.audiobookshelf.org)

**Offline (if you downloaded this):**
1. See [INSTALLATION_GUIDE_FOR_DUMMIES.md](INSTALLATION_GUIDE_FOR_DUMMIES.md)
2. Follow the steps to build it on your computer
3. Open `http://localhost:4567` in your web browser

### Step 3: Try Your First API Call

**Using Command Line (Mac/Linux/Windows with WSL):**

```bash
# Replace these with YOUR information:
# - http://192.168.1.100:13378 = your server address
# - your_username = your username
# - your_password = your password

curl -X POST "http://192.168.1.100:13378/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "your_username", "password": "your_password"}'
```

**What this does:**
- Sends a login request to your server
- Gets back a "token" (like a ticket that proves you're logged in)
- You use this token for all other requests

**Using a Web Browser Tool:**
1. Install [Postman](https://www.postman.com/) (free, easy to use)
2. Create a new POST request
3. Enter your server URL + `/login`
4. In the Body tab, select "raw" and "JSON"
5. Paste: `{"username": "your_username", "password": "your_password"}`
6. Click Send

---

## 📖 Reading the Documentation

### Understanding the Format

Each API endpoint is documented like this:

```
## Get All Libraries

GET /api/libraries
```

**What this means:**
- **"Get All Libraries"** = What it does (gets your list of audiobook/podcast libraries)
- **GET** = The HTTP method (like saying "please give me")
- **/api/libraries** = The URL path (where to send the request)

### Example Request

```bash
curl "https://abs.example.com/api/libraries" \
  -H "Authorization: Bearer your_token"
```

**Breaking it down:**
- `curl` = Command line tool for making requests
- The URL = Your server address + the path
- `-H` = Adding a "header" (extra information)
- `Authorization: Bearer your_token` = Proves you're logged in

### Example Response

```json
{
  "libraries": [
    {
      "id": "lib_123",
      "name": "Audiobooks"
    }
  ]
}
```

**What you get back:**
- `libraries` = An array (list) of your libraries
- Each library has an `id` and a `name`
- You can use the `id` to get books from that library

---

## 🔑 Common Terms Explained

### Authentication
**Fancy word for:** Proving who you are

**How it works:**
1. Send username + password to `/login`
2. Get back a "token" (random string like a password)
3. Include token in all future requests
4. Server knows it's you because you have the token

### Endpoint
**Fancy word for:** A specific API feature

**Example:**
- `/api/libraries` is an endpoint
- `/api/users` is a different endpoint
- Each endpoint does one thing

### Request
**Fancy word for:** Asking for something

**Parts of a request:**
- **Method** (GET, POST, DELETE, etc.) = What action you want
- **URL** = Where to send it
- **Headers** = Extra information (like your token)
- **Body** (sometimes) = Data you're sending

### Response
**Fancy word for:** The answer you get back

**Parts of a response:**
- **Status Code** (200 = success, 404 = not found, etc.)
- **Headers** = Extra information from the server
- **Body** = The actual data (usually in JSON format)

### JSON
**Fancy word for:** A way to format data

**Looks like:**
```json
{
  "name": "Harry Potter",
  "author": "J.K. Rowling",
  "duration": 28800
}
```

**Easy to read:**
- Curly braces `{}` = An object (group of data)
- Square brackets `[]` = An array (list of things)
- Quotes = Text
- No quotes = Numbers or true/false

---

## 🎓 Learning Path

### Total Beginner?

**Week 1: Learn the Basics**
1. Learn what APIs are: [API for Beginners](https://www.freecodecamp.org/news/what-is-an-api-in-english-please/)
2. Install Postman (easy way to test APIs without coding)
3. Try logging in to your Audiobookshelf server

**Week 2: Try Simple Requests**
1. Read the Quick Start guide
2. Try getting your libraries
3. Try getting books from a library
4. Try starting playback

**Week 3: Write Code**
1. Pick a programming language (JavaScript or Python recommended)
2. Copy one of our example clients
3. Modify it to do what you want
4. Build something cool!

### Some Programming Experience?

**Day 1:**
1. Read the Quick Start guide
2. Copy the JavaScript or Python client code
3. Try all the examples
4. Look at the Endpoint Matrix to see what else you can do

**Day 2:**
1. Pick a project (mobile app, web app, automation script)
2. Find the endpoints you need in the documentation
3. Start building!

**Day 3+:**
1. Read the detailed docs for each endpoint you use
2. Handle errors properly
3. Add features
4. Share your project with the community!

---

## 🆘 Common Questions

### "I don't know how to code. Can I still use this?"

**Not really.** This documentation is for programmers. But you can:
- Use Postman to test API calls (no coding required)
- Learn to code first (try [freeCodeCamp](https://www.freecodecamp.org/))
- Hire a developer to build something for you

### "What programming language should I use?"

**Any language works!** We have examples in:
- **JavaScript** - Best for web apps, React Native mobile apps
- **Python** - Best for scripts, automation, data analysis
- **Bash** - Best for quick tests, one-off commands

Pick whichever you're comfortable with!

### "I'm getting errors. What do I do?"

**Common fixes:**
1. **401 Unauthorized** = Wrong password or token expired
   - Solution: Log in again to get a new token

2. **404 Not Found** = Wrong URL or endpoint doesn't exist
   - Solution: Check the URL carefully, check the documentation

3. **500 Internal Server Error** = Something broke on the server
   - Solution: Check the Audiobookshelf server logs

4. **Connection refused** = Can't reach the server
   - Solution: Check server is running, check the URL, check firewall

### "Where do I get help?"

**Documentation help:**
- Open an issue: [GitHub Issues](https://github.com/AlmightyTopher/audiobookshelf-api-docs/issues)

**Audiobookshelf help:**
- Discord: [Join the Community](https://discord.gg/audiobookshelf)
- GitHub: [Main Repository](https://github.com/advplyr/audiobookshelf)
- Docs: [User Guide](https://www.audiobookshelf.org/docs)

### "Can I use this for free?"

**Yes!** Both Audiobookshelf and this documentation are 100% free and open source.

### "Can I build commercial apps with this?"

**Yes!** But check the Audiobookshelf license (GPL-3.0). Generally:
- ✅ Build apps for yourself
- ✅ Build apps for your company
- ✅ Sell apps to others
- ⚠️ If you modify Audiobookshelf itself, you must share your changes

---

## 🎯 Quick Links

| What You Want | Where to Go |
|---------------|-------------|
| **"Just show me working code!"** | [Quick Start Examples](QUICK_START_EXAMPLES.md) |
| **"What can the API do?"** | [Endpoint Matrix](ENDPOINT_MATRIX.md) |
| **"How do I install this?"** | [Installation Guide](INSTALLATION_GUIDE_FOR_DUMMIES.md) |
| **"What's new in this version?"** | [What's New](WHATS_NEW.md) |
| **"Which endpoints are documented?"** | [Coverage Report](API_COVERAGE_REPORT.md) |
| **"I want to read offline"** | Generate PDF: `./generate-pdf.sh` |

---

## 💡 Cool Project Ideas

### Beginner Projects
- Script to backup your listening progress
- Script to export your library to CSV
- Simple web page showing your statistics
- Bot that posts your reading stats to Discord

### Intermediate Projects
- Mobile app for iOS/Android
- Chrome extension for quick access
- Home Assistant integration
- Voice assistant skill (Alexa/Google Home)

### Advanced Projects
- Alternative web UI with new features
- Music player that also supports audiobooks
- Multi-server sync tool
- Analytics dashboard with charts

---

## 🌟 Tips for Success

### 1. Start Small
Don't try to build everything at once. Start with:
- Login
- Get libraries
- Get one book
- Celebrate! 🎉

Then add more features one at a time.

### 2. Read the Examples
We have complete, working code. Don't reinvent the wheel - copy and modify!

### 3. Test in Postman First
Before writing code, test the API in Postman to understand how it works.

### 4. Use the Search
The documentation has a search box. Use it!

### 5. Check Your Token
If things stop working, your token might have expired. Log in again.

### 6. Read Error Messages
Error messages tell you what's wrong. Read them carefully!

### 7. Ask for Help
The community is friendly! Don't be shy about asking questions.

---

## 🎊 You're Ready!

You now know:
- ✅ What this documentation is for
- ✅ Who should use it
- ✅ How to read it
- ✅ Where to get help
- ✅ What you can build

**Next step:**
Go to [INSTALLATION_GUIDE_FOR_DUMMIES.md](INSTALLATION_GUIDE_FOR_DUMMIES.md) to build the documentation locally, or just visit [api.audiobookshelf.org](https://api.audiobookshelf.org) to start reading!

**Happy coding! 🚀**

---

**Questions? Issues? Ideas?**
Open an issue on GitHub: https://github.com/AlmightyTopher/audiobookshelf-api-docs/issues

**Built with ❤️ by the Audiobookshelf community**
