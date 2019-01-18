1. use ssh-keygen command to generate a public/private key pair in client side
2. config remote linux host in accordance with procedure below
   i, create /root/.ssh directory and give permission
     --> mkdir /root/.ssh
     --> chmod 700 /root/.ssh
   ii, create file /root/.ssh/authorized_keys and copy the public key generated
   in client side, and save it
     --> vim /root/.ssh/authorized_keys
3. now finished configuration and can login linux host using ssh.
