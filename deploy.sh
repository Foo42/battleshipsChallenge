docker build -t battleships .
docker save battleships > /tmp/battleships.tar
scp /tmp/battleships.tar root@46.101.88.241:/tmp/battleships.tar
ssh root@46.101.88.241 'docker load /tmp/battleships.tar'
ssh root@46.101.88.241 'docker stop battleships'
ssh root@46.101.88.241 'docker rm battleships'
ssh root@46.101.88.241 'docker load < /tmp/battleships.tar'
ssh root@46.101.88.241 'docker run -p 80:4000 -d --name battleships battleships'