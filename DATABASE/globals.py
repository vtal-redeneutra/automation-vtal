from peewee import *
from dotenv import dotenv_values
config = dotenv_values('.env')
import json

db = MySQLDatabase(
    'ibm_vtal_db',
    user='admin',
    password='admin',
       host='localhost',
    port=3306
)


class Global(Model):
    Ambiente = CharField()
    URL_NETWIN = CharField()
    URL_FSL = CharField()
    URL_SOM = CharField()
    URL_Token = CharField()
    Usuario_NETQ = CharField()
    Senha_NETQ = CharField()
    Usuario_FSL = CharField()
    Senha_FSL = CharField()
    Usuario_SOM = CharField()
    Senha_SOM = CharField()
    Usuario_FW = CharField()
    Senha_FW = CharField()
    Usuario_OPM = CharField()
    Senha_OPM = CharField()
    Usuario_Netwin = CharField()
    Senha_Netwin = CharField()
    Usuario_Token = CharField()
    Senha_Token = CharField()
    Token = CharField()
    Validade_Token = CharField()
    Credencial = CharField()

    class Meta:
        database = db
        table_name = 'global'


db.create_tables([Global])



def criar_global(data):
    try:
        with db.atomic():
            for dados in data:
                print (dados)
                Global.create(**dados)
        print("Global criada com sucesso!")
    except IntegrityError:
        print("Sistema já existente!")


def ler_globais():
    globais = Global.select()
    # for param_global in globais:
    #     print(f"Sistema: {param_global.sistema}, Usuário: {param_global.usuario}, Senha: {param_global.senha}")    
    return globais
    

def ler_global_db(auth):
    try:
        # param_global = Global.get(Global.Credencial == auth)
        param_global = Global.select().where(Global.Credencial == auth)
        for a in param_global:
            return a
        # print(f"Validade Token: {param_global}")
        # return param_global
    except Global.DoesNotExist:
        print("Global não encontrada!")


def atualizar_global(sistema, novo_usuario, nova_senha):
    try:
        param_global = Global.get(Global.sistema == sistema)
        param_global.usuario = novo_usuario
        param_global.senha = nova_senha
        param_global.save()
        print("Global atualizada com sucesso!")
    except Global.DoesNotExist:
        print("Global não encontrada!")


def excluir_global(sistema):
    try:
        param_global = Global.get(Global.sistema == sistema)
        param_global.delete_instance()
        print("Global excluída com sucesso!")
    except Global.DoesNotExist:
        print("Global não encontrada!")




# IMPORTANDO GLOBAL 
def importarGlobal(): 
    global_data = './json/global.json'

    with open(global_data, encoding='utf8') as json_file:
        data = json.load(json_file)
    # print(data)
    Global.insert_many(data).execute()

