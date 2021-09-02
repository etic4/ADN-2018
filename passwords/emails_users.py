#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import os
import pwd
import shutil
import click

if os.path.dirname(__file__) == "/media/moi/partage/dev/passwords":
    MAILUSER = "vmail"
    DOMAIN = "discuss.r1x.ovh"
    VMAIL_BASEDIR = "/media/moi/partage/dev/emails/{domain}".format(domain=DOMAIN)
    PASSWD_PATH = "/media/moi/partage/dev/emails/passwd"
    VMAPS_PATH = "/media/moi/partage/dev/emails/vmaps"
    VALIAS_PATH = "/media/moi/partage/dev/emails/valias"
else:
    MAILUSER = "vmail"
    DOMAIN = "discuss.r1x.ovh"
    VMAIL_BASEDIR = "/home/vmail/{domain}".format(domain=DOMAIN)
    PASSWD_PATH = "/home/vmail/auth.d/{domain}/passwd".format(domain=DOMAIN)
    VMAPS_PATH = "/etc/postfix/vmaps"
    VALIAS_PATH = "/etc/postfix/valias"


def change_user(username):
    print("Changement d'utilisateur")
    pwnam = pwd.getpwnam(username)
    os.setgid(pwnam.pw_gid)
    os.setuid(pwnam.pw_uid)
    print("L'utilisateur est maintenant: {who}".format(who=subprocess.run(["whoami"], stdout=subprocess.PIPE).stdout.strip().decode("utf-8")))


def add_to(filepath, line):
    with open(filepath) as f:
        content = f.read()

    if not content.endswith("\n"):
        content += "\n"

    content += line + "\n"

    with open(filepath, "w") as f:
        f.write(content)

    print("'{line}' ajouté à {filepath}".format(line=line, filepath=filepath))


def remove_from(filepath, line_to_remove):
    with open(filepath) as f:
        content = f.read()

    lines = [line for line in content.split("\n") if line]
    lines.remove(line_to_remove)
    content = "\n".join(lines) + "\n"

    with open(filepath, "w") as f:
        f.write(content)

    print("'{line}' supprimée de {filepath}".format(line=line_to_remove, filepath=filepath))


def postmap():
    print("appel de 'postmap {valias}".format(valias=VALIAS_PATH))
    try:
        subprocess.run(["/usr/sbin/postmap", "/etc/postfix/valias"])
    except FileNotFoundError:
        print("FileNotFoundError")

    print("appel de 'postmap {vmaps}".format(vmaps=VMAPS_PATH))
    try:
        subprocess.run(["/usr/sbin/postmap", "/etc/postfix/vmaps"])
    except FileNotFoundError:
        print("FileNotFoundError")


def list_users():
    with open(VALIAS_PATH) as f:
        aliases_list = f.read().split("\n")

    usernames_list = [line.split()[0] for line in aliases_list if line]

    logins_list = [username.split("@")[0] for username in usernames_list if username]

    return logins_list


def get_passwd_line(email_address, password, dirpath):
    cmdline = ["/usr/bin/doveadm", "pw", "-s", "SHA512-CRYPT", "-p", "{password}".format(password=password)]
    hashed_passwd = subprocess.run(cmdline, stdout=subprocess.PIPE).stdout.decode("utf-8").strip()
    
    return "{email_address}:{hashed_passwd}:5000:5000::{dirpath}".format(email_address=email_address, hashed_passwd=hashed_passwd, dirpath=dirpath)


def get_passwd_line_from_login(login):
    with open(PASSWD_PATH) as f:
        content = [line for line in f.read().split() if line]

    for line in content:
        if login == line.split("@")[0]:
            return line


def get_params(login):
    email_address = "{login}@{domain}".format(login=login, domain=DOMAIN)
    dirpath = "{vmail_base_dir}/{login}".format(vmail_base_dir=VMAIL_BASEDIR, login=login)
    valias_line = "{email_address} {email_address}".format(email_address=email_address)
    vmaps_line = "{email_address} {domain}/{login}/".format(email_address=email_address, domain=DOMAIN, login=login)

    return email_address, dirpath, valias_line, vmaps_line


def create_user(login, password):
    if login in list_users():
        print("L'utilisateur '{login}' existe déjà!".format(login=login))
        return -1
    
    #schange_user(BECOME_USER)

    email_address, dirpath, valias_line, vmaps_line = get_params(login)
    passwd_line = get_passwd_line(email_address, password, dirpath)

    if not os.path.exists(dirpath):
        os.mkdir(dirpath)
        os.chmod(dirpath, 0o777)
        print("Répertoire {dirpath} créé".format(dirpath=dirpath))
    else:
        print("Répertoire {dirpath} pas créé, il existait déjà.".format(dirpath=dirpath))    

    add_to(VALIAS_PATH, valias_line)
    add_to(VMAPS_PATH, vmaps_line)
    add_to(PASSWD_PATH, passwd_line)

    postmap()

    return 0


def remove_user(login, remove_folder=True):
    if not login in list_users():
        print("L'utilisateur '{login}' n'existe pas!".format(login=login))
        return -1

    #change_user(BECOME_USER)
    
    email_address, dirpath, valias_line, vmaps_line = get_params(login)
    passwd_line = get_passwd_line_from_login(login)

    if remove_folder:
        shutil.rmtree(dirpath, ignore_errors=True)
        print("répertoire {dirpath} supprimé".format(dirpath=dirpath))

    remove_from(VALIAS_PATH, valias_line)
    remove_from(VMAPS_PATH, vmaps_line)
    remove_from(PASSWD_PATH, passwd_line)

    postmap()

    return 0


def remove_multiple_users(logins, keepfolder):
    logins = logins.replace(",", " ")
    logins_list = [username for username in logins.split(" ") if username]

    for username in logins_list:
        try:
            remove_user(username, keepfolder)
        except:
            pass

    return 0


@click.group()
def cli():
    pass


@cli.command()
@click.argument("login")
@click.argument("password")
def create(login, password):
    create_user(login, password)


@cli.command()
@click.argument("login")
@click.option('--keepfolder', default=False, is_flag=True)
def remove(login, keepfolder):
    remove_user(login, keepfolder)


@cli.command()
@click.argument("logins")
@click.option('--keepfolder', default=False, is_flag=True)
def remove_multiple(logins, keepfolder):
    remove_multiple_users(logins, keepfolder)


@cli.command()
def users():
    for user in list_users():
        print(user)


if __name__ == "__main__":
    cli()