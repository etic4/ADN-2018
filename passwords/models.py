#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from datetime import datetime
from peewee import *
import click
from playhouse.migrate import *

db = SqliteDatabase('passwapp.db')


def get_datetime(format="%d/%m/%Y %H:%M:%S"):
    return datetime.now().strftime(format)


class BaseModel(Model):
    class Meta:
        database = db


class Passwords(BaseModel):
    datetime = DateTimeField(default=get_datetime,formats=["%d/%m/%Y %H:%M:%S"])
    password = CharField()
    comment = CharField()
    clear_passw = TextField(default="")

    def __str__(self):
        return "<Passwords instance> date: {} :: hashed password: {} :: clear: {}".format(self.datetime, self.password, self.clear_passw)


def str2class(name):
    return getattr(sys.modules[__name__], name)


def list_table(table):
    for item in str2class(table):
        print("{}".format(item))


@click.group()
def cli():
    pass


@cli.command()
def initdb():
    db.connect()
    db.create_tables([Passwords])
    click.echo("Tables créées")


@cli.command()
def lsttables():
    """Liste les tables de la db
    """
    tables = db.get_tables()
    for table in db.get_tables():
        click.echo("{}".format(table))


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
    """initialise la table 'table'
    """
    str2class(table).create_table()
    click.echo("Table {} créée".format(table))


@cli.command()
@click.argument("table")
def lstitems(table):
    """Liste les enregistrements de la table 'table'
    """
    list_table(table)

@cli.command()
def lsth():
    """Liste les hashs
    """
    for res in Passwords.select():
        print(res.password)

@cli.command()
@click.argument("filepath")
def add_clear(filepath):
    """Ajout de mots de passe en clair à partir fichier
    """
    for line in open(filepath).read().split("\n"):
        i = line.find(":")
        if i < 0:
            continue
        hashed, clear_passw = line[:i], line[i+1:]
        query = Passwords.update(clear_passw = clear_passw).where(Passwords.password == hashed)
        query.execute()
        print(line)


def migrate_1():
    migrator = SqliteMigrator(db)
    migrate(migrator.add_column("passwords", "clear_passw", TextField(default="")))


if __name__ == '__main__':
    cli()
    # migrate_1()