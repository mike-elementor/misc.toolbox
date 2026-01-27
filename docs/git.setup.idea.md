Nice idea — this is a clean workflow 👍
You can totally do this with a tiny, portable Bash script that works on **Linux + macOS**.

Below is a **robust and simple** solution that reads from **stdin**, so it works exactly like:

```bash
cat ~/profile.work.txt | git-setup.sh
```

---

## 1️⃣ Input file format (`profile.work.txt`)

Let’s keep the profile file dead simple and readable:

```txt
email=john.doe@company.com
name=John Doe
```

Order doesn’t matter.

---

## 2️⃣ `git-setup.sh` (portable Bash)

```bash
#!/usr/bin/env bash
set -e

# Ensure we're inside a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

# Read key=value pairs from stdin
while IFS='=' read -r key value; do
  case "$key" in
    email) email="$value" ;;
    name)  name="$value" ;;
  esac
done

# Validate input
if [[ -z "$email" || -z "$name" ]]; then
  echo "❌ Missing email or name"
  exit 1
fi

# Apply local git config
git config --local user.email "$email"
git config --local user.name "$name"

echo "✅ Git local config set:"
echo "   user.name  = $name"
echo "   user.email = $email"
```

---

## 3️⃣ Make it executable

```bash
chmod +x git-setup.sh
```

(Optional: put it somewhere in your `$PATH`, like `~/bin`.)

---

## 4️⃣ Usage

From **inside a repo**:

```bash
cat ~/profile.work.txt | git-setup.sh
```

or even shorter:

```bash
git-setup.sh < ~/profile.work.txt
```

---

## 5️⃣ Why this is a good approach

✔ No `--global` pollution
✔ Per-repo identity (work / OSS / personal)
✔ Works in CI, containers, SSH sessions
✔ Linux + macOS compatible
✔ No `sed -i` portability issues

---

## 6️⃣ Optional upgrades (if you want)

### 🔹 Support comments and empty lines

Ignore lines starting with `#`:

```bash
[[ "$key" =~ ^#|^$ ]] && continue
```

### 🔹 Support multiple profiles

```bash
git-setup.sh < ~/.git-profiles/work
git-setup.sh < ~/.git-profiles/personal
```

### 🔹 Print current config before changing

```bash
git config --local --get user.name
git config --local --get user.email
```

---

If you want, I can also:

* make it **Zsh-only / POSIX-only**
* auto-detect profile by repo path
* add **dry-run mode**
* integrate with `direnv`

Just say the word 😄
