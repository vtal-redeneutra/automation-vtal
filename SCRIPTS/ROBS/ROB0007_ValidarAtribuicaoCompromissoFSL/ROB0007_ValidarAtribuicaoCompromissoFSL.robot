*** Settings ***
Documentation                               Validar Atribuição do Compromisso no FSL
Library                                     DateTime

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/FSL/UTILS.robot
Resource                                    ../../RESOURCE/FSL/PAGE_OBJECTS.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/DAT0001_InstalacaoFTTHSucessoViaFSL.xlsx
${WORKORDERID}
${INICIO_AGENDAMENTO}
${FINAL_AGENDAMENTO}
${ESTADO}


# *** Test Cases ***
# Valida Atribuicao do Compromisso no FSL
#     Validar Atribuicao Automatica FSL



*** Keywords ***
Validar Atribuicao Automatica FSL
    [Documentation]                         Validar Atribuição do Compromisso no FSL
    Logar no FSL
    BuiltIn.Sleep                           5
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              4927-0
    Consultar Data do Agendamento
    Consultar Relacionado
    Consultar Acao
    Fazer Logout

Validar Estado do pedido FSL
    [Documentation]                         Validar Estado do Compromisso no FSL
    Logar no FSL
    BuiltIn.Sleep                           5
    Consultar SA
    Consultar Estado
    Close Browser                           CURRENT

Validar a Criação do SA de Retirada
    [Documentation]                         Validar a Criação do SA de Retirada no FSL
    Logar no FSL
    BuiltIn.Sleep                           5 
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              407-0
    Consultar Data do Agendamento
    Close Browser                           CURRENT

Validar Criação do SA de Reparo
    [Documentation]                         Validar a Criação do SA de Reparo no FSL
    Logar no FSL
    BuiltIn.Sleep                           5 
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              4934-0
    Consultar Data do Agendamento
    Close Browser                           CURRENT

Validar SA de Reparo Bitstream no FSL
    [Documentation]                         Validar a SA de Reparo e Atribuição do compromisso no FSL Bitstream
    Logar no FSL
    BuiltIn.Sleep                           5 
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              4939-0
    Consultar Data do Agendamento
    Validar Pronto execucao
    Consultar Conta FSL                     TRGIBMTIMBIT
    Close Browser                           CURRENT

Validar SA de Reparo Bitstream no FSL simples
    [Documentation]                         Validar a SA de Reparo e Atribuição do compromisso no FSL Bitstream.
    ...                                     Não valida o Pronto Execucao e nem a Conta no FSL.
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Logar no FSL
    BuiltIn.Sleep                           5 
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              4939-0
    Consultar Data do Agendamento
    Close Browser                           CURRENT

Validar Atribuicao Automatica Bitstream FSL
    [Documentation]                         Validar Atribuição do Compromisso no FSL Bitstream
    Logar no FSL
    BuiltIn.Sleep                           5
    
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              4929-0
    Consultar Data do Agendamento
    Consultar Relacionado
    Consultar Acao
    Fazer Logout
    Close Browser                           CURRENT

Validar Atribuicao Automatica Voip
    [Documentation]                         Validar Atribuição do Compromisso no FSL Bitstream
    Logar no FSL
    BuiltIn.Sleep                           5
    
    Consultar SA
    Consultar Estado
    Consultar Tipo de Trabalho              4936-0
    Consultar Data do Agendamento
    Consultar Relacionado
    Consultar Acao
    Fazer Logout
    Close Browser                           CURRENT

Validar BA Oco no FSL
    [Documentation]                         Valida o BA oco no FSL. Deve estar Não Atribuído e sem Pronto Execução.

    Logar no FSL
    BuiltIn.Sleep                           5
    Consultar SA
    Consultar Estado Nao Atribuido
    Consultar Tipo de Trabalho              4936-0
    Consultar Atividade FSL                 INSTALAÇÃO BL + VOIP
    Consultar Data do Agendamento
    Validar SA Simples                      valorConta=                             valorOrigem=                            valorProntoExecucao=unchecked           validarEstado=False

#===========================================================================================================================================================================================================
Consultar Estado
    [Documentation]                         Função usada para ler o estado da SA E validar se está igual o valor da planilha, se estiver em execução ele pega a senha para ser usada no OPM.

    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    IF  "${ESTADO_SITE}" == "Não atribuído"
        Troca de Tecnico no Field Service  
    END

    IF  "${ESTADO_SITE}" == "Em execução"
        Click Web Element Is Visible        ${btn_ver_senha}
        ${Senha_FSL}=                       Get Text Element is Visible             ${campo_senha}
        Escrever Variavel na Planilha       ${Senha_FSL}                            senhaFsl                                Global
        Click Web Element Is Visible        ${btn_concluir}
    END 

#===========================================================================================================================================================================================================
Consultar Estado Nao Atribuido
    [Documentation]                         Função usada para ler o estado da SA E validar se está NÃO ATRIBUÍDO.

    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}
    Should Be Equal As Strings              ${ESTADO_SITE}                          Não atribuído                           ignore_case=true

#===========================================================================================================================================================================================================
Consultar Tipo de Trabalho
    [Documentation]                         Função usada para consultar o tipo de trabalho e comparar se está igual da planilha.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``Valor_Esperado`` | Valor do tipo do trabalho. exemplo: ``4927``. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Consultar Tipo de Trabalho            4927
    [Arguments]                             ${Valor_Esperado}

    ${TIPOTRABALHO_SITE}=                   Get Text Element is Visible             ${tipo_trabalho}

    IF  "${TIPOTRABALHO_SITE}" != "${Valor_Esperado}"
        Fatal Error                         \n Tipo de trabalho está diferente! Esperado: ${Valor_Esperado} Site: ${TIPOTRABALHO_SITE}
    END

#===========================================================================================================================================================================================================
Consultar Conta FSL
    [Documentation]                         Função usada para consultar a conta e comparar se está igual ao esperado.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``Valor_Esperado`` | Valor do tipo do trabalho. exemplo: ``Internet Bits`. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Consultar Conta FSL            Internet Bits
    [Arguments]                             ${Valor_Esperado}

    ${CONTA}=                               Get Text Element is Visible             ${conta_fsl}

    IF  "${CONTA}" != "${Valor_Esperado}"
        Fatal Error                         \n Conta no FSL está diferente! Esperado: ${Valor_Esperado} Site: ${CONTA}
    END

#===========================================================================================================================================================================================================
Consultar Atividade FSL

    [Documentation]                         Função usada para consultar a atividade e comparar se está igual ao esperado.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``Valor_Esperado`` | Valor do tipo de atividade. exemplo: ``INSTALAÇÃO BL + VOIP`. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Consultar Atividade FSL            INSTALAÇÃO BL + VOIP
    [Arguments]                             ${Valor_Esperado}

    ${ATIVIDADE}=                           Get Text Element is Visible             ${atividade_FSL}
    IF  "${ATIVIDADE}" != "${Valor_Esperado}"
        Fatal Error                         \n Conta no FSL está diferente! Esperado: ${Valor_Esperado} Site: ${ATIVIDADE}
    END

#===========================================================================================================================================================================================================
Validacao Basica FSL 
    [Documentation]                         Função usada para fazer uma consulta básica, sem as validações de inicio e final de agendamento.
    [Arguments]                             ${prioridadeCampo}=false

    Logar no FSL
    Consultar SA
     
    ${ESTADO_ESPERADO}=                     Ler Variavel na Planilha                Estado               	                Global
    Set Global Variable                     ${ESTADO_ESPERADO}

    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    IF  "${ESTADO_SITE}" != "${ESTADO_ESPERADO}"
        Fatal Error                         \n Estado está diferente de ${ESTADO_ESPERADO}
    END

    ${LyfeCycleStatus}=                     Ler Variavel na Planilha                lyfeCycleStatus                         Global  
    
    IF    '${LyfeCycleStatus}' == 'Cancelado'
        Log To Console                      Pedido foi cancelado.        
    ELSE
        Consultar Data do Agendamento
    END

    IF    "${prioridadeCampo}" != "false"
        Click Web Element Is Visible        xpath=//span[contains(text(),"Prioritário?")]/../..//img[@class=" checked"]
        Get Text Element is Visible         xpath=//span[contains(text(),"Cliente Diamond")]
    END   

    Close Browser                           CURRENT
#===========================================================================================================================================================================================================
Consultar Data do Agendamento
    [Documentation]                         Função usada para consultar e validar as datas de agendamento, inicio e final de agendamento, e comparar com o retorno da planilha.

    Scroll To Element                       ${FSL_INICIO_AGENDAMENTO}
    ${retorno_INICIO_AGENDAMENTO}=          Get Text Element is Visible             ${FSL_INICIO_AGENDAMENTO}
    ${retorno_FINAL_AGENDAMENTO}=           Get Text Element is Visible             ${FSL_FINAL_AGENDAMENTO}

    ${estadoNaoAtribuido}=                  Browser.Get Text                                ${estado_item}

    IF    "${estadoNaoAtribuido}" != "Não atribuído"

        IF  "${retorno_INICIO_AGENDAMENTO}" != "${INICIO_AGENDAMENTO}"
            Fatal Error                         \n Inicio do Agendamento está diferente! Planilha: ${INICIO_AGENDAMENTO} Site: ${retorno_INICIO_AGENDAMENTO}
        ELSE IF     "${retorno_FINAL_AGENDAMENTO}" != "${FINAL_AGENDAMENTO}"
            Fatal Error                         \n Final do Agendamento está diferente! Planilha: ${FINAL_AGENDAMENTO} Site: ${retorno_FINAL_AGENDAMENTO}
        END

    END

#===========================================================================================================================================================================================================
Validando Historico Agendamento 
    [Documentation]                         Função usada para validar o historico do agendamento e confirmar se foi cancelado o agendamento.

    Logar no FSL
     
    ${ESTADO_ESPERADO}=                     Ler Variavel na Planilha                Estado               	                Global
    Set Global Variable                     ${ESTADO_ESPERADO}

    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    IF  "${ESTADO_SITE}" != "${ESTADO_ESPERADO}"
        Fatal Error                         \n Estado está diferente de ${ESTADO_ESPERADO}
    END

    Click Web Element Is Visible            ${btn_relacionado}   
    Browser.Scroll By                       vertical=height
    Browser.Get Text                        xpath=//*[contains(text(),"Histórico de agendamento")]/../../../..//*[text()="Cancelamento do Agendamento"]             message= Elemento não encontrado.
    Fazer Logout
    Close Browser                           CURRENT

#===========================================================================================================================================================================================================
Valida SA Cancelada
    [Documentation]                         Função usada para validar se a SA foi cancelada, validando o Status como Cancelado, comparado o resultado com o da planilha.
    [Tags]                                  ValidaSACancelada

    Logar no FSL
    BuiltIn.Sleep                           5
    
    ${WORKORDERID}=                         Ler Variavel na Planilha                workOrderId                           Global
    Consultar SA
    
    Browser.Get Text                                ${status_cancelado}                     message="Não está cancelado no FSL."
    
    ${ESTADO_ESPERADO}=                     Ler Variavel na Planilha                Estado               	                Global
    Set Global Variable                     ${ESTADO_ESPERADO}

    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    IF  "${ESTADO_SITE}" != "${ESTADO_ESPERADO}"
        Fatal Error                         \n Estado está diferente de ${ESTADO_ESPERADO}
    END

    Close Browser                           CURRENT
    
#===================================================================================================================================================================
Validar SA Cancelada FSL
    #Valida mensagem do Historico de Agendamento
    [Documentation]                         Função usada para validar mensagem do Historico de Agendamento.
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``ESTADO_SITE`` | Valor do estado do site. exemplo: ``Cancelado``. |
    ...                                     | ``TEXTO`` | Valor epseraod do estado do site. exemplo: ``Cancelado``. |
    ...                                     Alguns exemplos de como usar a função: 
    ...                                     | Consultar Tipo de Trabalho            Cancelado                               Cancelado
    [Tags]                                  ValidaSACancelada
    [Arguments]                             ${ESTADO_SITE}                          ${TEXTO}                        

    Logar no FSL
    BuiltIn.Sleep                           5
    Consultar SA
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    Browser.Click                           ${btn_relacionado}
    Get Text Element is Visible Valida      //span[contains(@title,'${TEXTO}')]               ==                            ${TEXTO}

    Browser.Click                           //span[contains(@title,'${TEXTO}')]/../../..//th//span//div//a

    ${ESTADO_SITE}=                         Get Text Element is Visible             //span[contains(@title,'${TEXTO}')]
    IF  "${ESTADO_SITE}" != "${TEXTO}"
        Fatal Error                         \n Estado está diferente de ${TEXTO}

    END
    Close Browser                           CURRENT

#===================================================================================================================================================================
Validar SA Simples
    [Arguments]                             ${valorConta}
    ...                                     ${valorOrigem}
    ...                                     ${valorProntoExecucao}
    ...                                     ${validarEstado}=True
    [Documentation]                         Valida os campos Conta, Origem e Pronto Execução
    ...                                     | =Arguments= | =Description= |
    ...                                     | ``valorConta`` | . |

    Logar no FSL
    BuiltIn.Sleep                           5
    
    Consultar SA
    
    IF    "${validarEstado}" != "False"
        Consultar Estado
    END
    
    ${conta}                                Get Text Element is Visible             ${conta_fsl}
    Should Be Equal as Strings              ${conta}                                ${valorConta}                           msg=\n Conta no FSL está diferente do esperado! ${conta}!=${valorConta}
    
    ${origem}=                              Get Text Element is Visible             ${origemFSL}
    IF  "${origem}" != "${valorOrigem}"
        Fatal Error                         \n Origem no FSL está diferente do esperado!
    END

    ${prontoExecucao}=                      Get Class Element is Visible            ${check_pronto_execucao}
    IF  "${prontoExecucao[0]}" != "${valorProntoExecucao}"
        Fatal Error                         \n Status de Pronto Execução está diferente do esperado!
    END

    Close Browser                           CURRENT

#===================================================================================================================================================================