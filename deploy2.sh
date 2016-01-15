tar -zcvf /tmp/code.tar.gz .
scp /tmp/code.tar.gz root@46.101.88.241:/tmp/code.tar.gz
ssh root@46.101.88.241 'tar -zxvf /tmp/code.tar.gz'
ssh root@46.101.88.241 'cd /tmp/code && docker build -t battleships .'
ssh root@46.101.88.241 'docker stop battleships'
ssh root@46.101.88.241 'docker rm battleships'
ssh root@46.101.88.241 'docker load < /tmp/battleships.tar'
ssh root@46.101.88.241 'docker run -p 80:4000 -d --name battleships battleships'