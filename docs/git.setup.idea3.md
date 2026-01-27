Nice, this is exactly where scripts go from “handy” to “production-friendly” 😄
Here’s a **clean confirmation flow** with a `-y` / `--yes` flag for non-interactive automation.

---

## ✅ Updated `git-setup.sh` (with confirmation + `-y`)

```bash
#!/usr/bin/env bash
set -e

AUTO_YES=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -y|--yes)
      AUTO_YES=true
      shift
      ;;
    *)
      echo "❌ Unknown option: $1"
      exit 1
      ;;
  esac
done

# Ensure we're inside a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "❌ Not inside a git repository"
  exit 1
fi

# Read input
if [ -t 0 ]; then
  # Interactive input
  read -r -p "Git user name: " name
  read -r -p "Git user email: " email
else
  # From stdin
  IFS= read -r name || true
  IFS= read -r email || true
fi

# Trim whitespace (portable)
trim() {
  printf '%s' "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

name="$(trim "$name")"
email="$(trim "$email")"

# Validate input
if [[ -z "$name" || -z "$email" ]]; then
  echo "❌ Name or email is empty"
  exit 1
fi

# Show summary
echo
echo "About to set local Git config:"
echo "  user.name  = $name"
echo "  user.email = $email"
echo

# Confirmation
if ! $AUTO_YES; then
  read -r -p "Proceed? [y/N] " confirm
  case "$confirm" in
    y|Y|yes|YES) ;;
    *)
      echo "❌ Aborted"
      exit 1
      ;;
  esac
else
  echo "✔ Auto-confirm enabled (-y)"
fi

# Apply git config
git config --local user.name "$name"
git config --local user.email "$email"

echo
echo "✅ Git local config updated successfully"
```

---

## 🧪 Usage examples

### 📄 From profile file (with confirmation)

```bash
cat ~/profile.work.txt | git-setup.sh
```

Output:

```
About to set local Git config:
  user.name  = John Doe
  user.email = j.doe@ex.com

Proceed? [y/N]
```

---

### 🤖 Automation / CI / scripts

```bash
cat ~/profile.work.txt | git-setup.sh -y
```

No prompt, no pause.

---

### 💬 Fully interactive

```bash
git-setup.sh
```

You’ll be prompted for:

* name
* email
* confirmation

---

## 🧠 Design notes (why this is solid)

* `-y / --yes` mirrors common Unix conventions
* Confirmation defaults to **No** (safe by default)
* Works cleanly in:

  * CI
  * SSH
  * pipes
  * cron
* No GNU-only flags → macOS safe
* Script fails fast (`set -e`)

---

## 🔧 Easy extensions (if you want)

* Show **current local config** before confirmation
* Add `--force` to overwrite even if already set
* Add `--dry-run`
* Read from `.gitprofile` automatically if present
* Colorized output (still portable)

If you want this to feel like a first-class dev tool (or turn it into `git setup` via alias), I’m happy to help 😄

---

Absolutely — and yes, that’s *the* right instinct.
A tiny reusable `confirm()` function makes the script cleaner **and** scales nicely as you add more prompts.

Below is a **portable**, Bash-safe confirmation helper that respects `-y/--yes`.

---

## ✅ Reusable `confirm()` function

```bash
confirm() {
  local message="$1"

  if $AUTO_YES; then
    echo "✔ $message (auto-yes)"
    return 0
  fi

  read -r -p "$message [y/N] " reply
  case "$reply" in
    y|Y|yes|YES)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}
```

---

## 🔁 Updated usage inside your script

### Example: replacing inline confirmation

```bash
echo
echo "About to set local Git config:"
echo "  user.name  = $name"
echo "  user.email = $email"
echo

if ! confirm "Proceed with these settings?"; then
  echo "❌ Aborted"
  exit 1
fi
```

---

## 🧪 Example with multiple confirmations

```bash
confirm "Overwrite existing local Git config?" || exit 1

git config --local user.name "$name"
git config --local user.email "$email"

confirm "Do you want to display the current git config?" && \
  git config --local --list
```

---

## 🧠 Why this function is solid

* Works in **interactive & piped modes**
* Honors `-y / --yes`
* Default is **No** (safe)
* Uses return codes → idiomatic shell
* No arrays, no Bash 5 features → **macOS compatible**

---

## 🧩 Bonus: ultra-minimal version (if you like it tight)

```bash
confirm() {
  $AUTO_YES && return 0
  read -r -p "$1 [y/N] " r
  [[ "$r" =~ ^([yY]|yes)$ ]]
}
```

(Same behavior, fewer lines.)

---

If you want, next logical upgrades would be:

* `confirm_default_yes`
* `confirm_danger` (red prompt)
* timeout-based confirm
* non-interactive failure if no `-y`

You’re basically building a clean little CLI tool here — happy to keep polishing it with you 😄
