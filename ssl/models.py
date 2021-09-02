#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from hashlib import md5
from datetime import datetime
from peewee import *
from flask_login import UserMixin
import click


db = SqliteDatabase('dbapp.db')


def hash_password(password):
    if isinstance(password, str):
        password = password.encode("utf-8")
        
    return md5(password).hexdigest()


def get_datetime(format="%d/%m/%Y %H:%M:%S"):
    return datetime.now().strftime(format)


class BaseModel(Model):
    class Meta:
        database = db


class Login(UserMixin):
    def is_password_good(self, password):
        if password:
            return self.passwd_hash == hash_password(password)
        return False


class User(BaseModel, Login):
    user_name = CharField(unique=True)
    email = CharField(null=True)
    passwd_hash = CharField(null=True)
    passwd_clear = CharField(null=True)
    creation_date = DateTimeField(default=get_datetime,formats=["%d/%m/%Y %H:%M:%S"])
    active = BooleanField(default=True)
    is_admin = BooleanField(default=False)

    def __str__(self):
        return "<User instance> user_name: {} :: active: {} :: admin: {}".format(self.user_name, self.active, self.is_admin)


class Note(BaseModel):
    user =  ForeignKeyField(User, related_name='notes') 
    title = CharField()
    content = CharField()
    creation_date = DateTimeField(default=get_datetime,formats=["%d/%m/%Y %H:%M:%S"])
    is_public = BooleanField(default=False)

    def __str__(self):
        return "<Note instance> user: {} :: title: {} :: content: {}".format(self.user.user_name, self.title, self.content)

class Activity(BaseModel):
    user =  ForeignKeyField(User, related_name='activities')
    datetime = DateTimeField(default=get_datetime,formats=["%d/%m/%Y %H:%M:%S"])
    action = CharField()
    ip_addr = CharField(default="0.0.0.0")
    user_agent = CharField(default="")
    platform = CharField(default="")
    browser = CharField(default="")
    version = CharField(default="")

    def __str__(self):
            return "<Activity instance> user: {} :: date: {} :: action: {}".format(self.user.user_name, self.datetime, self.action)

def str2class(name):
    return getattr(sys.modules[__name__], name)


def list_table(table, nbr=100):
    for item in str2class(table).select().limit(nbr):
        print("{}".format(item))

def change_password(user, password):
    try:
        user = User.get(User.user_name == user)
        user.passwd_hash = hash_password(password) 
        user.passwd_clear = password
        user.save()
        print("Mot de passe changé")
    except User.DoesNotExist:
        print("L'utilisateur  n'existe pas")


@click.group()
def cli():
    pass


@cli.command()
def initdb():
    """Initialise la base de données et crée l'utilisteur 'Anonyme'
    """
    db.connect()
    db.create_tables([User, Note, Activity])
    click.echo("Tables créées")

    anonymous = User.create(user_name="Anonyme")
    anonymous.save()
    click.echo("Anonyme créé. Id: {}".format(anonymous.id))


@cli.command()
@click.argument("table")
def deltable(table):
    """Supprime la table 'table'
    """
    str2class(table).drop_table()
    click.echo("{} supprimée".format(table))


@cli.command()
@click.argument("table")
def mktable(table):
    """Crée la table 'table'
    """
    str2class(table).create_table()
    click.echo("Table {} créée".format(table))


@cli.command()
@click.argument("table")
def lstitems(table):
    """Liste tous les items de la table 'table'
    """
    list_table(table)


@cli.command()
@click.argument("user")
@click.argument("password")
def chgpass(user, password):
    """Change mot de passe
    """
    change_password(user, password)


@cli.command()
@click.argument("user_name")
def deluser(user_name):
    """Supprime utilisateur et toutes les notes associées
    """
    try:
        user = User.select().where(User.user_name == user_name).get()
        user.delete_instance(recursive=True)
        print("Utilisateur {} supprimé".format(user_name))
    except:
        pass

if __name__ == '__main__':
    # user = User.select().where(User.user_name == "Moi").get()
    # notes = list(Note.select().where(Note.user == user.id))
    # for note in notes:
    #     print(note.title)
    cli()

    # user = User.select().where(User.user_name == "Moi").get()
    # print(user)

