*** Settings ***
Documentation                               Realiza a Troca de Tecnico via FSL
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/FSL/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot

*** Variables ***
# ${DAT_CENARIO}                              C:/IBM_VTAL/DATA/DAT0019_InstalaçãoFTTHComAgendamentoEncerramentoComSucessoViaOPM.xlsx
${WORKORDERID}


# *** Test Cases ***
# Troca de Tecnico e data de agendamento via FSL
#     [Documentation]                       Realiza a Troca de Tecnico via FSL
#     [Tags]                                TrocaTecnicoFSL
#     Troca de Tecnico via FSL


*** Keywords ***

#===========================================================================================================================================================================================================
Troca de Tecnico no Field Service
    [Documentation]                         Acessa menu vendas, filtra Compromissos de Serviços e pesquisa o SA. Verifica o estado da SA, se já estiver como atribuído, retorna "troca de técnico não necessária".
    ...                                     \nSe ainda não estiver como atribuído, realizará a atribuição para o técnico " Luciana Vago Matieli ". Valida se o estado está como "detached", e agenda para esse técnico para 2h a frente.
    ...                                     \nFaz uma nova consulta da SA para verificar se estado está como atribuído.
    Desatribui de Tecnico via FSL

    Logar no FSL
    BuiltIn.Sleep                           5

    ${Atribuir_tecnico}                     Ler Variavel na Planilha                atribuirTecnico                         Global 
    Set Global Variable                     ${Atribuir_tecnico}
    
    #Entra na pagina do Field Service
    Click Web Element Is Visible            ${btn_iniciador}
    Click Web Element Is Visible            ${btn_visualizar_tudo}
    Click Web Element Is Visible            ${btn_field_service}

    #Troca a politica para "Custumer First"
    Select Element is Visible               ${btn_politica}                         Customer First
    Input Text Web Element Is Visible       ${input_pesquisar_SA}                   ${WORKORDERID}
    
    Sleep                                   10s

    # ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    ${btn_pesquisar_todos_registro}    Visible    15s
    # IF  ${EXIST} == True
    #     Click Web Element Is Visible            ${btn_pesquisar_todos_registro}
    # END

    Click Web Element Is Visible            ${SA_field_service}
    Click Web Element Is Visible            ${btn_candidatos}

    #Seleciona o tecnico que está descrito na param_global
    Click Web Element Is Visible            css=iframe[lang="pt-BR"] >>> //h1[contains(text(),'${Atribuir_tecnico}')]/..
    Click Web Element Is Visible            css=iframe[lang="pt-BR"] >>> //h1[contains(text(),'${Atribuir_tecnico}')]/../..//*[contains(text(),'Atribuir')]
    
    Consultar SA
    # Fazer Logout
    # Close Browser                           CURRENT

#===========================================================================================================================================================================================================