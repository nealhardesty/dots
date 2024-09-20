mkdir -p ~/.ssh

git config --global user.email "nealhardesty@yahoo.com"
git config --global user.name "Neal Hardesty"
git config --global core.fileMode false

git config pull.rebase false

ssh-keyscan github.com >> ~/.ssh/known_hosts