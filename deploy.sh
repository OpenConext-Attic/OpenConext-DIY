#!/bin/sh
ansible-playbook -i inventory --ask-become-pass openconext-diy.yml
