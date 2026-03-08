Claude code integration in OpenCode:
- claude code init
- check in ~/.claude/credentials.json
- take the accessToken and add it in the OpenCode when connecting to Anthropic 

How to prepare the host fs to share permissions:
groudadd -g 1000 opencode
cd .config
chgrp  -R 1000 .gh
chgrp  -R 1000 .gh opencode/
sudo chgrp  -R 1000 .gh opencode/
sudo chgrp  -R 1000 gh opencode/
cd github/getinspiredbythebible
chgrp -R 1000 getinspiredbythebible



docker compose -f ./docker-compose-sandbox-v4.yml build opencode-sandbox



On the client side
opencode attach http://localhost:4096 -s ses_33dc7306cffeNyfefWQb7w6MZL


docker compose -f ./docker-compose-sandbox-v4.yml logs  -f

AICLI_WORKSPACE="../getinspiredbythebible" docker compose -f ./docker-compose-sandbox-v4.yml up
