from peewee import *
from dotenv import dotenv_values
config = dotenv_values('.env')
from robot.api.deco import keyword

db = MySQLDatabase(
    'ibm_vtal_db',
    user='admin',
    password='admin',
    host='localhost',
    port=3306
)


class DAT(Model):
    atribuirTecnico = CharField() 
    customerName = CharField() 
    phoneNumber = CharField() 
    Reference = CharField() 
    Address = CharField() 
    Number = CharField() 
    typeComplement1 = CharField() 
    value1 = CharField() 
    typeComplement2 = CharField() 
    value2 = CharField() 
    typeComplement3 = CharField() 
    value3 = CharField() 
    typeLogradouro = CharField() 
    addressName = CharField() 
    addressId = CharField() 
    UF = CharField() 
    Cidade = CharField() 
    Bairro = CharField() 
    inventoryId = CharField() 
    availabilityDescription = CharField() 
    maxBandWidth = CharField() 
    associatedDocumentDate = CharField() 
    appointmentStart = CharField() 
    appointmentFinish = CharField() 
    associatedDocument = CharField() 
    subscriberId = CharField() 
    workOrderId = CharField() 
    correlationOrder = CharField() 
    osOrderId = CharField() 
    LyfeCycleStatus = CharField() 
    creationDate = CharField() 
    somOrderId = CharField() 
    Estado = CharField() 
    senhaFsl = CharField() 
    responsavel = CharField()
    system = CharField()
    step = CharField()

    class Meta:
        database = db
        table_name = 'dat'


db.create_tables([DAT])


def criar_tabela():
    db.create_tables([DAT])

def criar_dat(responsavel):
    try:
        query = DAT(responsavel=responsavel)
        query.save()
        print(query.id)
        
        # query = DAT.insert(addressId=data, responsavel=responsavel)
        # print(query.id)
        print("DAT criada com sucesso!")
        return query.id
    except IntegrityError:
        print("DAT já existente!")


def ler_credenciais():
    credenciais = DAT.select()
    for dat in credenciais:
        print(f"Cep: {dat.Cep}, Numero: {dat.Numero}, CodSurvey: {dat.CodSurvey}")


@keyword('Buscar Dat Do Usuario')
def buscar_dat_do_usuario(responsavel, step):
    try:
        # dat = DAT.get((DAT.responsavel == responsavel) & (DAT.step == step))
        dat = DAT.select().where((DAT.responsavel == responsavel) & (DAT.step == step)).order_by(DAT.id.desc()).get()
        return dat
    except DAT.DoesNotExist:
        print("DAT não encontrada!")

@keyword('Buscar Campo Dat Id')
def buscar_dat_by_id(id):
    try:
        print(id)
        # print(campo)
        busca = DAT.get(DAT.id == id)
        # print(f"Campo: {busca.campo}")
        return busca
    except DAT.DoesNotExist:
        print("DAT não encontrada!")

def atualizar_dados_dat_by_id(id, coluna, valor):
    try:
        dat = DAT.get(DAT.id == id)
        setattr(dat, coluna, valor)
        dat.save()
        dados = buscar_dat_by_id(id)
        return dados
        print("DAT atualizado com sucesso!")
    except DAT.DoesNotExist:
        print("DAT não encontrada!")


def atualizar_dados_dat(AddressId, coluna, valor):
    try:
        dat = DAT.get(DAT.addressId == AddressId)
        setattr(dat, coluna, valor)
        dat.save()
        print("DAT atualizado com sucesso!")
    except DAT.DoesNotExist:
        print("DAT não encontrada!")

def atualizar_steps_dat(id, Responsavel, System, newStep):
    try:
        dat = DAT.get((DAT.id == id) & (DAT.responsavel == Responsavel))
        dat.step = newStep
        dat.system = System
        dat.save()
        print("DAT atualizado com sucesso!")
    except DAT.DoesNotExist:
        print("DAT não encontrada!")
    
def excluir_dat(sistema):
    try:
        dat = DAT.get(DAT.sistema == sistema)
        dat.delete_instance()
        print("DAT excluído com sucesso!")
    except DAT.DoesNotExist:
        print("DAT não encontrada!")