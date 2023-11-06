*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Number, CancelAppointmentReason, CancelAppointmentComments
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,
...
...                                         Antes de testar o script, verifique se os campos "CorrelationOrder" e "AssociatedDocument" estão vazios na DAT, assim como "AppointmentStart" e "AppointmentFinish", caso contrário apresentará erro.


Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot  
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0019_ValidarPendenciaSOM/ROB0019_ValidarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0020_ValidarPendenciaFWConsole/ROB0020_ValidarPendenciaFWConsole.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/005_AtivacaoSemAgendamentoComTratamentoPendenciaCliente.xlsx


*** Test Cases ***
05.01 - Gerar Token de Acesso
    Retornar Token Vtal

05.02-3 - Realizar Consulta de Logradouro
    Consulta Id Logradouro

05.04-6 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

05.07 - Realizar Consulta de Slots
    Consulta Slot Agendamento

05.08-9 - Realizar Abertura de OS sem Agendamento
    Criar Ordem Agendamento

05.10 - Validar a Abertura da OS com Pendência de Agendamento - SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}
    ...                                     ${SOM_Pendencia_Grupo}                  ${SOM_Pendencia_Nome}                   

    @{RETORNO}=                             Create List                             associatedDocument
    ...                                     grupoPendenciaSom                       pendenciaSom

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=I002 - Tratar Pendencia Cliente
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

# 05.11 - Validar Notificação de Abertura da OS com Pendência de Cliente via FW Console
#     Validar Evento FW                       VALOR_BUSCA=Associated_Document    
#     ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderCreateEvent'])[1]
#     ...                                     RETORNO_ESPERADO=>200<

05.12 - Realizar Agendamento
    Realizar Agendamento

05.13 - Realizar o Tratamento a Pendência
    Tratamento da Pendência

05.14 - Realizar Validação no SOM
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    ${SOM_Numero_SA}       
    ...                                     ${SOM_Pendencia_Nome}                   ${SOM_Pendencia_Grupo}

    @{RETORNO}=                             Create List                             associatedDocument                      workOrderId
    ...                                     pendenciaSom                            grupoPendenciaSom

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

05.15 - Realizar Validação no FWConsole
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PatchProductOrder'])[1]
    ...                                     RETORNO_ESPERADO=>200<
