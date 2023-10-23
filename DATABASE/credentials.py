from peewee import *
from dotenv import dotenv_values
config = dotenv_values('.env')


db = MySQLDatabase(
    'ibm_vtal_db',
    user='admin',
    password='admin',
       host='localhost',
    port=3306
)


class Credencial(Model):
    sistema = CharField(unique=True)
    usuario = CharField()
    senha = CharField()

    class Meta:
        database = db
        table_name = 'credencial'


db.create_tables([Credencial])



def criar_credencial(sistema, usuario, senha):
    try:
        Credencial.create(sistema=sistema, usuario=usuario, senha=senha)
        print("Credencial criada com sucesso!")
    except IntegrityError:
        print("Sistema já existente!")


def ler_credenciais():
    credenciais = Credencial.select()
    for credencial in credenciais:
        print(f"Sistema: {credencial.sistema}, Usuário: {credencial.usuario}, Senha: {credencial.senha}")


def ler_credencial_db(sistema):
    try:
        credencial = Credencial.get(Credencial.sistema == sistema)
        print(f"Sistema: {credencial.sistema}, Usuário: {credencial.usuario}, Senha: {credencial.senha}")
        return credencial
    except Credencial.DoesNotExist:
        print("Credencial não encontrada!")


def atualizar_credencial(sistema, novo_usuario, nova_senha):
    try:
        credencial = Credencial.get(Credencial.sistema == sistema)
        credencial.usuario = novo_usuario
        credencial.senha = nova_senha
        credencial.save()
        print("Credencial atualizada com sucesso!")
    except Credencial.DoesNotExist:
        print("Credencial não encontrada!")


def excluir_credencial(sistema):
    try:
        credencial = Credencial.get(Credencial.sistema == sistema)
        credencial.delete_instance()
        print("Credencial excluída com sucesso!")
    except Credencial.DoesNotExist:
        print("Credencial não encontrada!")



# criar_credencial("ApiWhitelabel", "d6c3e319-d388-4128-96f8-154da4c71526", "0917ff46-9ed9-4dea-babd-baba3e2a55e3")
# criar_credencial("ApiBitstream",  "44437e20-2ac6-4c67-9673-a320267fc6a7", "153fdbe8-7135-42b4-9049-280366b8056a")
# criar_credencial("ApiVoip",  		"c8638a55-a7f4-490e-b24b-5fa641050d42", "ccf52c77-9b7e-4c64-83cd-20ff7ad3f1de")
# criar_credencial("ApiCpoi",  		"c8638a55-a7f4-490e-b24b-5fa641050d42", "ccf52c77-9b7e-4c64-83cd-20ff7ad3f1de")

# atualizar_credencial("ApiWhitelabel", "d6c3e319-d388-4128-96f8-154da4c71526", "0917ff46-9ed9-4dea-babd-baba3e2a55e3")

# excluir_credencial("Sistema2")


# ler_credenciais()
