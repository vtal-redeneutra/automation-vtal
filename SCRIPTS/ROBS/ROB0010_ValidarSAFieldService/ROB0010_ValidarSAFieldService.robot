*** Settings ***
Documentation                               Valida a finalização da SA no Field Service
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/FSL/UTILS.robot

*** Variables ***
${WORKORDERID}


#*** Test Cases ***
#Validacao da SA Field Service
     #[Documentation]                         Valida a finalização da BA no Field Service
     #[Tags]                                  ValidaSANoFieldService
    #Valida SA no Field Service


*** Keywords ***
Valida SA no Field Service
    [Tags]                                  ValidaSAFieldService
    [Arguments]                             ${atividadeSA}=INSTALAÇÃO BL FIBRA
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nValida a finalização da BA no Field Service
    Logar no FSL
    BuiltIn.Sleep              5
    Consultar SA
    Validar SA no Field Service             ${atividadeSA}
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
Valida Tecnico Habilitado no Field Service
    [Arguments]                             ${habilitacao}
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nValida a finalização da BA no Field Service
    Logar no FSL
    BuiltIn.Sleep              5
    Consultar SA
    Consulta Habilidades no Field Service   habilitacao=${habilitacao}
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
Validar SA no Field Service
    [Arguments]                             ${atividadeSA}=INSTALAÇÃO BL FIBRA
    [Documentation]                         Valida a finalização da BA no Field Service.
    ...                                     \nAcessa o FSL para consulta e validar o SA, verifica se a atividade é diferente de "INSTALAÇÃO BL FIBRA", ser for, retorna fatal error "atividade diferente".
    ...                                     \nEm caso de sucesso tira screenshot.

    Sleep                                   2s
    Click Web Element Is Visible            ${btn_iniciador}
    Click Web Element Is Visible            ${btn_visualizar_tudo}
    Click Web Element Is Visible            ${btn_field_service}
    Wait for Elements State                 ${input_pesquisar_SA}                   Visible                                 timeout=${TIMEOUT}
    Input Text Web Element Is Visible       ${input_pesquisar_SA}                   ${WORKORDERID}
    Sleep                                   7s
    ${validacao_btn_SA}=                    Get Element States                      ${btn_pesquisar_todos_registro}
    
    Log to console                          ${validacao_btn_SA}

    ${Associated_Document}                  Ler Variavel na Planilha                associatedDocument                    Global
    
    Sleep                                   3s

    ${EXIST}=  Run Keyword And Return Status    Wait for Elements State    ${btn_pesquisar_todos_registro}    Visible    15
    IF    ${EXIST} == True
        Click Web Element Is Visible            ${btn_pesquisar_todos_registro}
    END

    Click Web Element Is Visible            ${SA_field_service}

    ${Atividade_SA}=                        Get Text Element is Visible             ${atividade}
    ${documento_associado}=                 Get Text Element is Visible             ${doc_associado}
    ${pronto_execucao}=                     Get Text Element is Visible             ${pronto_exec}

    IF  "${Atividade_SA}" != "${atividadeSA}" and "${documento_associado}" == "${Associated_Document}" and "${pronto_execucao}" == "true"
            Fatal Error                     \nAtividade está diferente 
    END

    Click Web Element Is Visible            ${btn_editar}
    Sleep                                   7s
    Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}                
    
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
Consulta Habilidades no Field Service
    [Arguments]                             ${habilitacao}
    [Documentation]                         Valida habilidades dos Tecnico no Field Service.
    ...                                     \n
    
    ${tecnicoHabilitado}                    Ler Variavel na Planilha                atribuirTecnico                         Global
    # ACESSA O FIELD SERVICE
    Sleep                                   2s
    Click Web Element Is Visible            ${btn_iniciador}
    Click Web Element Is Visible            ${btn_visualizar_tudo}
    Click Web Element Is Visible            ${btn_field_service}
    Wait for Elements State                 ${btnFiltrosTabela}                     Visible                                 timeout=${TIMEOUT}

    # CLICA NO FILTRO DA TABELA E SELIECIONA HABLIDADES
    Click Web Element Is Visible            ${btnFiltrosTabela}
    Click Web Element Is Visible            ${btnFiltroHabilidades}
    # Check CheckBox Element is Visible       ${checkHabilitarHabilidades}
    # Check CheckBox Element is Visible       css=iframe[lang="pt-BR"] >>> //label[@title='${habilitacao}']/../input
    Click Web Element Is Visible            css=iframe[lang="pt-BR"] >>> //span[@class='pill-label truncate'][contains(.,'${habilitacao}')]
    Click Web Element Is Visible            ${btnFiltrosTabela}

    # VALIDA SE O TECNICO ESTÁ HABILITADO AO SERVIÇO
    Sleep                                   3s
    ${statesTecnicos}                       Get Element States                      css=iframe[lang="pt-BR"] >>> //a[@title='Eduardo Berg']
    
    ${validaTecnico}    Run Keyword And Return Status    Wait for Elements State    css=iframe[lang="pt-BR"] >>> //a[@title='Eduardo Berg']    attached    15
    IF    ${validaTecnico} == False
        Fatal Error                         \nO técnico não está habilitado ao serviço.
    END

    Close Browser                           CURRENT