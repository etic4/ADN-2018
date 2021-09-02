#!/usr/bin/python3
# -*- coding: utf-8 -*-

import click

@click.group()
def cli():
    pass

@cli.command()
def initdb():
    click.echo('Initialized the database')

@cli.command()
def dropdb():
    click.echo('Dropped the database')

@cli.command()
@click.argument("table")
@click.option("--first", is_flag=True, help="Le premier seulement")
def list(table, first):
    click.echo(table)
    if first:
        click.echo("first seulement")

def password()

if __name__ == '__main__':
    cli()