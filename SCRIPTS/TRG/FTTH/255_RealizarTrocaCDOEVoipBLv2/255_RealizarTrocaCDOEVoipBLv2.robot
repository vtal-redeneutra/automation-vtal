*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0047_RealizarTrocaCDOE/ROB0047_RealizarTrocaCDOE.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/255_RealizarTrocaCDOEVoipBLv2.xlsx


*** Test Cases ***
255.01 - Gerar Token de Acesso
    Retornar Token Vtal

255.02 - Realizar Consulta de Logradouro
    Consulta Logradouro CPOi

255.03 - Realizar Consulta de Complemento
    Id Consulta Complemento

255.04 - Realizar Consulta de Viabilidade
    Retorna Viabilidade dos Produtos

255.05 - Realizar Consulta de Slots
    Retornar Slot Agendamento V2            productType=Banda Larga,VoIP

255.06 - Realizar o Agendamento
    Realizar Agendamento V2                 appointmentReason=Instalacao de Fibra

255.07 - Validar BA Oco no FSL
    Validar BA Oco no FSL

255.08 - Realizar a Criação de Ordem (OS)
    Criar Ordem de Agendamento Voip V2

255.09 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.PostProductOrder.v2.5'])[1]
    ...                                     RETORNO_ESPERADO=>Sucesso<

255.10/11/12 - Realizar troca de CDOE
    Trocar CDOE via SOM

XX.XX - Atualização da data de agendamento via API
    Reagendar Pedido OPM e FSL              activityType=4936

255.13/15/17 - Realizar o Encerramento da OS de Instalação via FSL
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H

# 255.14/16/18 - Validar Mudança de Status no FW Console
#     ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY                    

#     Validar Mudancas de Estado FW           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent        tns:name   
 
255.19 - Auditoria de Tarefas
    Auditoria de Tarefas

255.20 - Validar no Field Service
    Valida SA no Field Service              INSTALAÇÃO BL + VOIP

255.21 - Realizar Validação de Retorno via SOM
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

255.22 - Validar a Notificação de Encerramento via FW Console
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='SingleNotificationManagement.SOM'])[1]
    ...                                     XPATH_XML=//*[text()="Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso para Banda Larga e VOIP OI<