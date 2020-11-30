#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request

## Libs postgres
import psycopg2
import psycopg2.extras

app = Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt";
DB_USER="ist193739";
DB_DATABASE=DB_USER
DB_PASSWORD="miguel2000";
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD);


## Runs the function once the root page is requested.
## The request comes with the folder structure setting ~/web as the root
@app.route('/')
def list_accounts():
  dbConn=None
  cursor=None
  try:
    return render_template("index.html");
  except Exception as e:
    return str(e); #Renders a page with the error.
  finally:
    cursor.close();
    dbConn.close();

@app.route('/medicos');
def list_medics():
  dbConn=None;
  cursor=None;
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT num_cedula, nome, especialidade FROM medico;"
    cursor.execute(query);
    return render_template("medicos.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) ;
  finally:
    cursor.close();
    dbConn.close();

@app.route('/balance');
def alter_balance():
  try:
    return render_template("balance.html", params=request.args);
  except Exception as e:
    return str(e);



@app.route('/delete', methods=["DELETE"]);
def remove():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING);
    cursor = dbConn.cursos(cursor_factory = psycopg2.extras.DictCursor);
    if request.name == "RemoveMedic":
      query = f'''DELETE FROM medico WHERE num_cedula = '{request.form["RemoveMedic"]}';'''
    elsif request.name == "RemoveInst":
      query = f'''DELETE FROM instituicao WHERE nome = '{request.form["RemoveInst"]}';'''
    elsif request.name == "RemovePresc":
      query = f'''DELETE FROM prescricao WHERE num_cedula = '{request.form["RemovePresc"]}';'''
    elsif request.name == "RemoveAnalise":
      query = f'''DELETE FROM analise WHERE num_analise = '{request.form["RemoveAnalise"]}';'''
    cursor.execute(query);
    return query;
  finally:
    dbConn.commit();
    dbConn.close();


@app.route('/update', methods=["POST"]);
def update_balance():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING);
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor);
    # Esta versão é vuneravel a SQL injection
    query = f'''UPDATE account SET balance={request.form["balance"]} WHERE account_number = '{request.form["account_number"]}';'''
    cursor.execute(query);
    return query;
  except Exception as e:
    return str(e) ;
  finally:
    dbConn.commit();
    dbConn.close();


CGIHandler().run(app);
