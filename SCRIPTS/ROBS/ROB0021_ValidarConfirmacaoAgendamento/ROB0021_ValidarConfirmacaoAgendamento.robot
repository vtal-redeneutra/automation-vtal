*** Settings ***
Documentation                               Validação da confirmação do agendamento da BA no FWConsole
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/FW/UTILS.robot
  

*** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/DAT012_RealizarAtivacaoSemPendencia.xlsx
${date}
${correlationOrder}
${associatedDocument}
${observation}
${action}
${userId}


# *** Test Cases ***
# Validando a confirmacao do agendamento
#     Validando o agendamento


*** Keywords ***
Validando o agendamento
    [Tags]                                  ValidarAgendamentoFW
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nFaz login no FW, Preenche o Work_Order_Id, e valida a confirmação de agendamento da BA.

    Login FWConsole
    Preencher o Work_Order_Id
    Validar Confirmacao de Agendamento da BA
    Close Browser                           CURRENT

Validando o Bloqueio
    [Tags]                                  ValidaBloqueioFW
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nFaz login no FW, consulta Associated_Document e valida o bloqueio total.

    Login FWConsole
    ${Associated_Document}=                 Ler Variavel na Planilha                Associated_Document                     Global
    Set Global Variable                     ${Associated_Document}
    Validar Confirmacao de Bloqueio Total
    Close Browser                           CURRENT

Validando o Desbloqueio
    [Tags]                                  ValidaDesbloqueioFW
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nFaz login no FW, consulta Associated_Document e valida o desbloqueio total.

    ${Associated_Document}=                 Ler Variavel na Planilha                Associated_Document                     Global
    Set Global Variable                     ${Associated_Document}
    Validar Confirmacao de Desbloqueio Total
    Close Browser                           CURRENT

#====================================================================================================================================
Preencher o Work_Order_Id
    [Tags]                                  preencherWorkOrderId
    [Documentation]                         Consulta e pega o Work_Order_Id da planilha.

    ${WORKORDERID}=                         Ler Variavel na Planilha                Work_Order_Id                       	Global
    Set Global Variable                     ${WORKORDERID}