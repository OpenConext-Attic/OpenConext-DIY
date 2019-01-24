FROM ubuntu:16.04

EXPOSE 443

RUN apt -y update && apt -y full-upgrade && apt -y autoremove && apt install -y --no-install-recommends sudo dnsutils git software-properties-common
RUN apt-add-repository -y ppa:ansible/ansible && apt -y update && apt install -y ansible
RUN apt-get install -y vim
RUN apt -y clean

RUN git clone https://github.com/OpenConext/OpenConext-DIY.git /tmp/ansible/openconext-diy
RUN echo "target ansible_host=127.0.0.1\n\n[idp]\ntarget\n" > /tmp/ansible/openconext-diy/inventory

RUN  ansible-playbook -i /tmp/ansible/openconext-diy/inventory /tmp/ansible/openconext-diy/openconext-diy.yml --extra-vars "ansible_connection=local"

VOLUME ["/var/www/simplesamlphp/metadata"]

# Alternatively to mounting the docker metadata as a volume, you can copy it on build
#COPY docker/metadata /var/www/simplesamlphp/metadata

RUN rm -rf /tmp/ansible/openconext-diy

ENTRYPOINT service apache2 start & /bin/bash
