*** Settings ***
Documentation                               Atualizar o Estado do Status do SA
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/FSL/UTILS.robot

*** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/DAT0001_InstalacaoFTTHSucessoViaFSL.xlsx
${WORKORDERID}


# *** Test Cases ***
# Atualizar o Estado do Status do SA
#     [Documentation]                       Atualizar o Estado do Status do SA
#     [Tags]                                AtualizaEstadoStatusSA
#     Atualiza Status SA


*** Keywords ***
Atualiza Status SA
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nAtualizar o Estado do Status do SA
    Logar no FSL
    BuiltIn.Sleep                           5
    Consultar SA
    Validar Pronto execucao
    Alteracao Status
    Close Browser                           CURRENT

Atualiza Status Deslocamento SA 
    [Documentation]                         Keyword encadeador TRG
    ...                                     \nAtualiza o status até "Em deslocamento"                                   
    Logar no FSL
    BuiltIn.Sleep                           5
    Consultar SA
    Validar Pronto execucao
    Alteracao Status Deslocamento
    Close Browser                           CURRENT


#===========================================================================================================================================================================================================
Validar Pronto execucao
    [Documentation]                         Valida se o status Pronto Execução está "checked"
    ...                                     \nEnquanto o status estiver diferente de "checked", recarrega a página até 5 vezes e gera Fatal Error
    Click Web Element Is Visible            ${btn_detalhes}

    ${Pronto_Execucao}=                     Get Class Element is Visible            ${check_pronto_execucao}

    ${Counter}=                             Set Variable                            1

    WHILE   "${Pronto_Execucao}" != "checked"
        Sleep                           5s
        Reload
        ${Counter}=                         Evaluate                                ${Counter} + 1
        IF  "${Counter}" == "10" 
            Fatal Error                     \nSe passou muito tempo e o Pronto Execução não ficou Checked
        END
    END

#===========================================================================================================================================================================================================
Alteracao Status
    [Documentation]                         Altera o status até "Em execução"
    ...                                     \nPreenche o campo "Estado" da planilha com o valor do Status
    ${STATUS}=                              Get Text Element is Visible             ${estado_item}
    
    WHILE    "${STATUS}" != "Em execução"
        Click Web Element Is Visible                                                ${btn_marcar_concluido}
        Click Web Element Is Visible                                                ${btn_concluir}
        Sleep                               2s
        ${STATUS}=                          Get Text Element is Visible             ${estado_item}
    END

    Escrever Variavel na Planilha           Em execução                             Estado                                  Global

#===========================================================================================================================================================================================================
Alteracao Status Deslocamento
    [Documentation]                         Altera o status até "Em deslocamento"
    ...                                     \nPreenche o campo "Estado" da planilha com o valor do Status
    ${STATUS}=                              Get Text Element is Visible             ${estado_item}
    
    WHILE    "${STATUS}" != "Em deslocamento"
        Click Web Element Is Visible                                                ${btn_marcar_concluido}
        Click Web Element Is Visible                                                ${btn_concluir}
        ${STATUS}=                          Get Text Element is Visible             ${estado_item}
    END

    Escrever Variavel na Planilha           Em deslocamento                         Estado                                  Global

#===========================================================================================================================================================================================================