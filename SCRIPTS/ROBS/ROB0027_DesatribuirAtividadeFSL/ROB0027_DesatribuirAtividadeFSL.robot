*** Settings ***
Documentation                               Desatribui de Tecnico via FSL
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/FSL/UTILS.robot
Resource                                    ../../ROBS/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot

*** Variables ***
# ${DAT_CENARIO}                              C:/IBM_VTAL/DATA/DAT0019_InstalacaoFTTHComAgendamentoEncerramentoComSucessoViaOPM.xlsx
${WORKORDERID}


# *** Test Cases ***
# Desatribuicao de Tecnico via FSL
#     [Documentation]                       Realiza a Desatribuição de Tecnico via FSL
#     [Tags]                                DesatribuiTecnicoFSL
#     Desatribui de Tecnico via FSL


*** Keywords ***

#===========================================================================================================================================================================================================
Desatribui de Tecnico via FSL
    [Documentation]                         Função usada para logar no FSL, consultar a SA e desatribuir um técnico no sistema FSL através do Field Service.

    Logar no FSL
    BuiltIn.Sleep                           5

    ${estadoSA}=                            Get Text Element is Visible             ${estado_item}  

    IF  "${estadoSA}" == "Não atribuído"
        Log to console                      O pedido já está não atribuido, desatribuição do técnico não será necessário. 
    ELSE
        Click Web Element Is Visible        ${btn_relacionado}
        Click Web Element Is Visible        ${button_exibir_tudo}    
        Sleep                               3s
        Click Web Element Is Visible        ${button_excluir_tecnico}
        Sleep                               2S
        Click Web Element Is Visible        ${button_excluir}  
        Click Web Element Is Visible        ${caixa_excluir} 
        Sleep                               2s
        Consultar SA

        ${ESTADO_SITE}=                     Get Text Element is Visible             ${estado_item}
        ${Counter}=                         Set Variable                            1

        WHILE   "${ESTADO_SITE}" != "Não atribuído"
            Sleep                           2s
            Reload
            ${Counter}=                     Evaluate                                ${Counter} + 1
            ${ESTADO_SITE}=                 Get Text Element is Visible             ${estado_item}
            IF  "${Counter}" == "25" 
                Fatal Error                 nSe passou muito tempo e não ficou Concluído com sucesso
            END
        END
    END
    Consultar SA
    # Close Browser                           CURRENT
#===========================================================================================================================================================================================================
