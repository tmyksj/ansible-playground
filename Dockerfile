FROM ubuntu

ARG ANSIBLE_PASSWORD=my-secret-pw
ARG ANSIBLE_PASSWORD_SALT=aa

RUN apt update; \
    apt install -y nano; \
    \
    apt install -y openssh-server; \
    mkdir -p /run/sshd; \
    \
    apt install -y software-properties-common; \
    apt-add-repository -y -u ppa:ansible/ansible; \
    apt install -y ansible python-argcomplete; \
    \
    apt install -y perl sudo; \
    groupadd ansible; \
    useradd -g ansible -G sudo -m -p $(perl -e "print crypt('$ANSIBLE_PASSWORD', '$ANSIBLE_PASSWORD_SALT')") ansible; \
    su -c " \
        ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa; \
        cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys; \
        chmod 600 ~/.ssh/authorized_keys; \
        echo 'StrictHostKeyChecking no' > ~/.ssh/config; \
        chmod 600 ~/.ssh/config; \
        " ansible

CMD ["/usr/sbin/sshd", "-D"]
