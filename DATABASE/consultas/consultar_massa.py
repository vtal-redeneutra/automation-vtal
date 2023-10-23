from peewee import *
from dotenv import dotenv_values
config = dotenv_values('.env')
from robot.api.deco import keyword
import sys
from tabulate import tabulate

db = MySQLDatabase(
    'ibm_vtal_db',
    user='admin',
    password='admin',
       host='localhost',
    port=3306
)


class DAT(Model):
    Atribuir_tecnico = CharField() 
    Customer_Name = CharField() 
    Phone_Number = CharField() 
    Reference = CharField() 
    Address = CharField() 
    Number = CharField() 
    TypeComplement1 = CharField() 
    Value1 = CharField() 
    TypeComplement2 = CharField() 
    Value2 = CharField() 
    TypeComplement3 = CharField() 
    Value3 = CharField() 
    Type_Logradouro = CharField() 
    Address_Name = CharField() 
    Address_Id = CharField(unique=True) 
    UF = CharField() 
    Cidade = CharField() 
    Bairro = CharField() 
    TypeComplement2 = CharField() 
    Value2 = CharField() 
    TypeComplement3 = CharField() 
    Value3 = CharField() 
    Inventory_Id = CharField() 
    Availability_Description = CharField() 
    MaxBandWidth = CharField() 
    Associated_Document_Date = CharField() 
    Appointment_Start = CharField() 
    Appointment_Finish = CharField() 
    Associated_Document = CharField() 
    Subscriber_Id = CharField() 
    Work_Order_Id = CharField() 
    Correlation_Order = CharField() 
    slotId = CharField() 
    OS_Order_Id = CharField() 
    SOM_Order_Id = CharField() 
    Estado = CharField() 
    Senha_FSL = CharField()
    Responsavel = CharField()
    System = CharField()
    Step = CharField()

    class Meta:
        database = db
        table_name = 'dat'


db.create_tables([DAT])




def buscar_endereco_nao_utilizado(resp):
    try:
        # dat = DAT.get(DAT.Responsavel == resp)
        dats = DAT.select().where((DAT.Responsavel == resp))

       # Prepare the data for the table
        table_data = []
        for dat in dats:
            table_data.append([dat.Address_Id, dat.UF, dat.Associated_Document, dat.Work_Order_Id, dat.System, dat.Step])

        # Display the results in a grid format
        headers = ['Address_Id', 'UF',   'Associated_Document', 'Work_Order_Id', 'System', 'Step']
        table = tabulate(table_data, headers, tablefmt='grid')
        print(table)
        
        # return dat
    except DAT.DoesNotExist:
        print("Nenhum Endereco encontrado!")
    
for parametro in sys.argv:
        # buscar_dat_do_usuario(parametro)
        buscar_endereco_nao_utilizado(parametro)
