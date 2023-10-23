from peewee import *
import json
from dotenv import dotenv_values
config = dotenv_values('.env')



db = MySQLDatabase(
    'ibm_vtal_db',
    user='admin',
    password='admin',
    host='localhost',
    port=3306
)


class Endereco(Model):
    Cep = CharField(null=False)
    Numero = CharField()
    Comp_1 = CharField()
    Comp_2 = CharField()
    Comp_3 = CharField()
    UF = CharField()
    Municipio = CharField()
    Bairro = CharField()
    CodSurvey = CharField(unique=True)
    Logradouro = CharField()
    Viabilidade = CharField()
    AddressId = CharField()
    Usage = BooleanField(default=False)

    class Meta:
        database = db
        table_name = 'endereco'


db.create_tables([Endereco])


def criar_endereco(data):
    try:
        Endereco.create(data)
        print("Endereco criada com sucesso!")
    except IntegrityError:
        print("Endereco já existente!")


def ler_credenciais():
    credenciais = Endereco.select()
    for endereco in credenciais:
        print(f"Cep: {endereco.Cep}, Numero: {endereco.Numero}, CodSurvey: {endereco.CodSurvey}")


def ler_endereco_por_sistema(CodSurvey):
    try:
        endereco = Endereco.get(Endereco.CodSurvey == CodSurvey)
        print(f"Cep: {endereco.Cep}, Numero: {endereco.Numero}, CodSurvey: {endereco.CodSurvey}")
    except Endereco.DoesNotExist:
        print("Endereco não encontrado!")


def buscar_endereco_nao_utilizado(Uf,Municipio):
    try:
        # endereco = Endereco.get(Endereco.Usage == False)
        # endereco = Endereco.get((Endereco.Usage == False) & (Endereco.UF == Uf) & (Endereco.Municipio == Municipio))
        endereco = Endereco.get((Endereco.Usage == False) & (Endereco.UF == Uf) & (Endereco.Municipio == Municipio))
        print(endereco)
        # print(f"Cep: {endereco.Cep}, Numero: {endereco.Numero}, CodSurvey: {endereco.CodSurvey}, UF: {endereco.UF}, Municipio: {endereco.Municipio}")
        
        return endereco
    except Endereco.DoesNotExist:
        print("Nenhum Endereco encontrado!")
    

def atualizar_endereco(data):
    try:
        endereco = Endereco.get(Endereco.CodSurvey == data.CodSurvey)
        endereco.Usage = True
        endereco.save()
        print("Endereco atualizado com sucesso!")
    except Endereco.DoesNotExist:
        print("Endereco não encontrado!")


def excluir_endereco(sistema):
    try:
        endereco = Endereco.get(Endereco.sistema == sistema)
        endereco.delete_instance()
        print("Endereco excluído com sucesso!")
    except Endereco.DoesNotExist:
        print("Endereco não encontrado!")
        

   
# IMPORTANDO ENDEREÇOS 
def importarEnderecos(): 
    endereco_data = './json/endereco.json'

    with open(endereco_data, encoding='utf8') as json_file:
        data = json.load(json_file)
    # print(data)
    Endereco.insert_many(data).execute()


