#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request, redirect, url_for
from datetime import date, datetime

## Libs postgres
import psycopg2
import psycopg2.extras
import sys

app = Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt";
DB_USER="ist193739";
DB_DATABASE=DB_USER
DB_PASSWORD="srnt8881";
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD);

## Runs the function once the root page is requested.
## The request comes with the folder structure setting ~/web as the root
@app.route('/')
def index():
  try:
    return render_template("index.html");
  except Exception as e:
    return str(e); #Renders a page with the error.


@app.route('/farmacia')
def farmacia():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT * FROM venda_farmacia;"
    cursor.execute(query)
    return render_template("farmacia.html", cursor=cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/glicemia')
def glicemia():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT max(quant), num_doente, nome_concelho \
    FROM((SELECT quant, inst, num_doente FROM analise \
    WHERE nome = glicemia) as a\
    NATURAL JOIN(SELECT num_concelho FROM instituicao)  as i\
    NATURAL JOIN(SELECT nome as nome_concelho FROM concelho) as c)\
    GROUP BY nome_concelho\
    UNION\
    SELECT min(quant), num_doente, nome_concelho \
    FROM((SELECT quant, inst, num_doente\
    FROM analise WHERE nome = glicemia) as a\
    NATURAL JOIN(SELECT num_concelho FROM instituicao)  as i\
    NATURAL JOIN(SELECT nome as nome_concelho FROM concelho) as c)\
    GROUP BY nome_concelho"
    cursor.execute(query)
    return render_template("glicemia.html", cursor = cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()

@app.route('/medicos')
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

@app.route('/instituicoes')
def list_instituicao():
  dbConn=None;
  cursor=None;
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT nome, tipo, num_regiao, num_concelho FROM instituicao;"
    cursor.execute(query);
    return render_template("instituicao.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) ;
  finally:
    cursor.close();
    dbConn.close();

@app.route('/prescricoes')
def list_prescricoes():
  dbConn=None;
  cursor=None;
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT num_cedula, num_doente, data_consulta, substancia, quant FROM prescricao;"
    cursor.execute(query);
    return render_template("prescricoes.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) ;
  finally:
    cursor.close();
    dbConn.close();

@app.route('/analises')
def list_analises():
  dbConn=None;
  cursor=None;
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    query = "SELECT num_analise, especialidade, num_cedula, num_doente, data_consulta, data_registo, nome, quant, inst FROM analise;"
    cursor.execute(query);
    return render_template("analises.html", cursor=cursor, params=request.args)
  except Exception as e:
    return str(e) ;
  finally:
    cursor.close();
    dbConn.close();


"""
COMO É QUE ARRANJA O NUMERO DA ULTIMA VENDA PARA INCREMENTAR
"""
@app.route('/compra', methods=["POST"])
def compra():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    argsPresc = []
    args = []
    if request.form["btn"] == "compraPresc":
      argsPresc.append(request.form["num_cedula"])
      argsPresc.append(request.form["num_doente"])
      argsPresc.append(request.form["data"])
      argsPresc.append(request.form["substancia"])
      argsPresc.append(vendas_farmacia)
      query = f"insert into prescricao_venda values (%s, %s, %s, %s, %s);"
      cursor.execute(query, argsPresc)

    args.append(vendas_farmacia)
    args.append(date.today())
    args.append(request.form["substancia"])
    args.append(request.form["quantidade"])
    args.append("12")
    args.append("hospital")
    query = f"insert into venda_farmacia values (%s, %s, %s, %s, %s, %s);"
    cursor.execute(query, args)
    return redirect(url_for('index'))
  except Exception as e:
    return str(e) ;
  finally:
    dbConn.commit()
    cursor.close()
    dbConn.close()


@app.route('/infoDoente', methods=["POST"])
def info():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    num_doente = request.form["num_doente"]
    query = f"SELECT * FROM prescricao WHERE num_doente = %s;"
    cursor.execute(query, num_doente)
    #check if cursor is empty (no rows) if true render template cursor=none else that
    return render_template("infoDoente.html", cursor=cursor)
  except Exception as e:
    return str(e) ;
  finally:
    cursor.close()
    dbConn.close()

@app.route('/alterar', methods=["POST"])
def alterar():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    args = []
    if request.form["btn"] == "AlterarMedico":
      if request.form["coluna"] == "nome":
        query = f"UPDATE medico SET nome = %s WHERE num_cedula = %s;"
      elif request.form["coluna"] == "especialidade":
        query = f"UPDATE medico SET especialidade = %s WHERE num_cedula = %s;"
      args.append(request.form["valor"])
      args.append(request.form["num_cedula"])
      url = "list_medics"

    elif request.form["btn"] == "AlterarInstituicao":
      if request.form["coluna"] == "num_regiao":
        query = f"UPDATE instituicao SET num_regiao = %s WHERE nome = %s;"
      elif request.form["coluna"] == "num_conselho":
        query = f"UPDATE instituicao SET num_regiao = %s WHERE nome = %s;"
      args.append(request.form["valor"])
      args.append(request.form["nome"])
      url = "list_instituicao"

    elif request.form["btn"] == "AlterarPrescricao":
      args.append(request.form["valor"])
      args.append(request.form["data"])
      args.append(request.form["substancia"])
      query = f"UPDATE prescricao SET substancia = %s WHERE data_consulta = %s AND substancia = %s;"
      url = "list_prescricoes"

    elif request.form["btn"] == "AlterarAnalise":
      if request.form["coluna"] == "especialidade":
        query = f"UPDATE analises SET especialidade = %s WHERE num_analise = %s;"
      elif request.form["coluna"] == "nome":
        query = f"UPDATE analises SET nome = %s WHERE num_analise = %s;"
      args.append(request.form["valor"])
      args.append(request.form["num_analise"])
      url = "list_analises"
    cursor.execute(query, args)
    return redirect(url_for(url))
  except Exception as e:
    return str(e) ;
  finally:
    dbConn.commit()
    cursor.close()

@app.route('/insert', methods=["POST"])
def inserir():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    args = []
    if request.form["btn"] == "AddMedic":
      args.append(request.form["num_cedula"])
      args.append(request.form["nomeMedico"])
      args.append(request.form["especialidade"])
      query = f"insert into medico values (%s, %s, %s)"
      url = "list_medics"
    elif request.form["btn"] == "AddInst":
      args.append(request.form["nome"])
      args.append(request.form["tipo"])
      args.append(request.form["regiao"])
      args.append(request.form["concelho"])
      query = f"insert into instituicao values (%s, %s, %s, %s)"
      url = "list_instituicao"
    elif request.form["btn"] == "AddPresc":
      args.append(request.form["num_cedula"])
      args.append(request.form["num_doente"])
      args.append(request.form['data_consulta'])
      args.append(request.form["substancia"])
      args.append(request.form["quant"])
      query = f"insert into prescricao values (%s, %s, %s, %s, %s)"
      url = "list_prescricoes"
    elif request.form["btn"] == "AddAnalise":
      args.append(request.form["num_analise"])
      args.append(request.form["especialidade"])
      args.append(request.form["num_cedula"])
      args.append(request.form["num_doente"])
      args.append(request.form["data_consulta"])
      args.append(request.form["data_registo"])
      args.append(request.form["nome"])
      args.append(request.form["quant"])
      args.append(request.form["inst"])
      query = f"insert into analise (%s, %s, %s, %s, %s, %s, %s, %s, %s);"
      url = "list_analises"
    cursor.execute(query, args)
    return redirect(url_for(url))
  except Exception as e:
    return str(e) ;
  finally:
    dbConn.commit()
    cursor.close()


@app.route('/mostrapresc', methods=["POST"])
def mostrapresc():
  dbConn=None
  cursor=None
  args = []
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
    args.append(request.form["num_cedula"])
    args.append(request.form["data_consulta"])
    query = "SELECT num_cedula, substancia, data_consulta FROM prescricao WHERE num_cedula = %s AND data_consulta = %s;"
    cursor.execute(query, args)
    return render_template("mostrapresc.html", cursor=cursor)
  except Exception as e:
    return str(e)
  finally:
    cursor.close()
    dbConn.close()


@app.route('/delete', methods=["POST"])
def remove():
  dbConn=None
  cursor=None
  try:
    dbConn = psycopg2.connect(DB_CONNECTION_STRING)
    cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)

    if request.form["btn"] == "RemoveMedic":
      value = request.form["num_cedula"]
      query = f"DELETE FROM medico WHERE num_cedula = {value}"
      url = "list_medics"
    elif request.form["btn"] == "RemoveInst":
      value = request.form["value"]
      query = f"DELETE FROM instituicao WHERE nome = '{value}'"
      url = "list_instituicao"
    elif request.form["btn"] == "RemovePresc":
      value = request.form["value"]
      value2 = request.form["value2"]
      value3 = request.form["value3"]
      value4 = request.form["value4"]
      query = f"DELETE FROM prescricao WHERE num_cedula = {value} AND num_doente = {value2} AND data_consulta = '{value3}' AND substancia = {value4}"
    elif request.form["btn"] == "RemoveAnalise":
      value = request.form["value"]
      query = f"DELETE FROM analise WHERE num_analise = {value}"
      url = "list_analises"
    cursor.execute(query)
    return redirect(url_for(url))
  except Exception as e:
    return str(e)
  finally:
    dbConn.commit()
    cursor.close()

CGIHandler().run(app)
