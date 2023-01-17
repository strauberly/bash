#! /bin/bash

printf "\x1b[38;5;79m\nThe New Repo Script © Adam Straub 2023\x1b[0m\n";
#You are more than welcome to use this, please just give the devil his due ^_-.

printf "\x1b[38;5;75m\nEnter repo name:\x1b[0m\n";
read repo

printf "\x1b[38;5;75m\nEnter description:\x1b[0m\n";
read description


printf "\x1b[38;5;75m\nEnter GitHub password:\x1b[0m\n";
stty -echo
read gitpw
stty echo


printf "\x1b[38;5;75m\nEnter Bitbucket password:\x1b[0m\n";
stty -echo
read bitpw
stty echo

: '
github api call to create repo.
documentation found -> 
https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28
'

curl -s -X POST \
	-H "Accept: application/vnd.github+json" \
	-H "Authorization: token $gitpw" \
    -d "{ \"name\": \"$repo\", \"description\": \"$description\"}" \
	-H "X-GitHub-Api-Version: 2022-11-28" \
	'https://api.github.com/user/repos' > /dev/null

printf "\x1b[38;5;160;1m\n!!Github Repo Created!!\x1b[0m\n\n";
sleep 1

: '
bitbucket api call to create repo.
documentation found -> 
https://developer.atlassian.com/cloud/bitbucket/rest/api-group-repositories/#api
-group-repositories
'
# Replace <username> with your bitbucket username.
curl -s -X POST -u <username>:$bitpw  \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
  "is_private": false,
  "description": "'"$description"'",
  "project": {
    "key": "PORTF"
  }
}' \
--url "https://api.bitbucket.org/2.0/repositories/<username>/$repo" > /dev/null

printf "\x1b[38;5;160;1m\n!!Bitbucket Repo Created!!\x1b[0m\n\n";
sleep 1

printf "\x1b[38;5;75;1m\nInitiating local repo...\x1b[0m\n\n";
sleep 1

# Modify to suite your needs.
touch README.md;
echo "# $repo" > README.md;

# Modify to suite your needs.
touch .gitignore
(
echo "#IGNORE THE FOLLOWING FILES"
echo
echo node_modules
echo .next 
echo .env
echo .client.js
echo .properties
echo .config
)>.gitignore;

: '
Configured for dual platform push.
Replace <username> with your username for the appropriate platform.  
'

git init;

git remote add all https://github.com/<username>/$repo.git;
git remote add gitHub https://github.com/<username>/$repo.git;
git remote add bitBucket https://<username>@bitbucket.org/<username>/$repo.git

git remote -v
sleep 3

git remote set-url --add --push all \
https://github.com/<username>/$repo.git;
git remote set-url --add --push all \
https://<username>@bitbucket.org/<username>/$repo.git

git checkout -b main;
git branch;
sleep 1

git status;
sleep 3

git add *;
git commit -am"Repo init";
git push all main;


#At this point the cli's for github and bibucket kick in and you will need to 
#enter user name for github and passwords for each. 


printf "\x1b[38;5;75;1m\nLocal repo initialized and first push 
complete. All set there bub, have fun.\x1b[0m\n\n";
sleep 5
cat /dev/null > ~/.bash_history && history -c && exit

