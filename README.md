# Status-bot 🟢
## ⚠️ Project Archived - Not maintained ⚠️
> This project is no longer maintained. It is based on an obsolete version of Node.js and no longer works with recent versions. It will not be updated.
## Bot for auto update status on Github and Gitlab
### For use it
### 1# Init
```
Set-up a token on Github and Gitlab for API
Copy example.config.json to config.json
replace XXX with your token
```
in .build
```
npm install
```
### 2# Build
```
haxe build.hxml
```
### 3# Configuration
```
cp example.config.json config.json
nano config.json
# Edit with your configuration
``` 
### 4# Start-it
```
node .build/main.js
```
