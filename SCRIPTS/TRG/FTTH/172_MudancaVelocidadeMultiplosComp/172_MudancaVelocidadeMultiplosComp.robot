*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
    ...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0016_RealizarMudancaVelocidade/ROB0016_RealizarMudancaVelocidade.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot


*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/172_MudancaVelocidadeMultiplosComp.xlsx


*** Test Cases ***
172.01 - Gerar Token de Acesso
    Retornar Token Vtal

172.02/03 - Realizar Mudança de Velocidade
    Mudar Velocidade                        true                                    true                                    CatalogADD=1000                         CatalogREMOVE=400

172.04 - Validar Notificação no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Extrair dado do Bloco                   START - Inicialização do serviço        tns:id                                  somOrderId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso

172.05 - Realizar validação no SOM 
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Header_OrderID}                   

    @{RETORNO}=                             Create List                             associatedDocument                      somOrderId                                       
                                      
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Modificacao de Velocidade
    ...                                     ORDER_STATE=Completed
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

172.06 - Validação do Encerramento no Microserviços
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]       Ordem Encerrada com Sucesso