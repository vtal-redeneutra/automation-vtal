*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
    ...                                     INPUT: Address, Number, Customer_Name, Phone_Number, Reference, 
    ...                                     OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,


Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_MS}/UTILS.robot

Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0028_AgendamentoDeRetirada/ROB0028_AgendamentoDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0029_CriarOrdemDeRetirada/ROB0029_CriarOrdemDeRetirada.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/170_RetiradaSucessoSemPendenciasBLVoipEnderecoMultiplosComplementos.xlsx


*** Test Cases ***

170.01 - Gerar Token de Acesso 
    Retornar Token Vtal

170.02 - Realizar Consulta de Slots Para Atividade de Retirada
    Retornar Slot Agendamento Retirada      CodActivityType=4937

170.03 - Realizar Agendamento de Retirada
    Realizar Agendamento de Retirada        CodActivityType=4937

170.04 - Realizar Abertura da Ordem de Retirada
    Criar Ordem de retirada 4937  

170.05 - Validar Notificação de Criação da Ordem no Microserviços
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Extrair dado do Bloco                   START - Inicialização do serviço        id                                      somOrderId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso


170.06 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    
    ...                                     ${SOM_Cliente_idContrato}                     

    @{RETORNO}=                             Create List                             associatedDocument                      
    ...                                     subscriberId                            

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T063 - Retirar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Retirada 
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

170.07 - Realizar Reagendamento
    Reagendar Pedido OPM e FSL Retirada     CodactivityType=4937

170.09 - Realizar Atribuição ao Técnico via FLS
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

170.10.12.14 - Realizar o Encerramento de Retirada
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Atualiza Status SA
    Atualizar e Encerrar sem Extravio

170.11.13.15 - Validar Mudança de Status do FSL no Microserviços
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

170.16 - Validar o Encerramento da Ordem no SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Retirada
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT
    
170.17 - Valida a Notificação de Encerramento no Microserviços
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]       Ordem Encerrada com Sucesso
