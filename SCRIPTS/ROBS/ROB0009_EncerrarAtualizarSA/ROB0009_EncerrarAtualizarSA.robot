*** Settings ***
Documentation                               Atualizar e Encerrar o SA
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot
Resource                                    ../../RESOURCE/FSL/UTILS.robot
Resource                                    ../../RESOURCE/OPM/UTILS.robot
Resource                                    ../../RESOURCE/SOM/UTILS.robot

*** Variables ***
# ${DAT_CENARIO}                            C:/IBM_VTAL/DATA/TRG_FTTH_DAT_001_AtivacaoSemComplementoViaFSL.xlsx
${WORKORDERID}
${Counter}

# *** Test Cases ***
# Atualizar o Estado do Status do SA
#     [Documentation]                       Atualizar o Estado do Status do SA
#     [Tags]                                AtualizaEstadoStatusSA
#     Atualizar e Encerrar o SA


*** Keywords ***
Atualizar e Encerrar o SA
    [Documentation]                         Atualizar e Encerrar o SA
    [Tags]                                  AtualizarSA
    Logar no FSL
    Consultar SA
    Preencher Auxilio
    Validar Itens das ordens de trabalho para execucao
    Valida inclusao de Materiais e Equipamentos
    Validar Itens das ordens de trabalho apos a execucao
    Encerrar com Sucesso

Atualizar e Encerrar o SA CPOI
    [Arguments]                             ${EQUIPAMENTO}=ONT HW - HG8245H
    [Documentation]                         Atualizar e Encerrar o SA
    [Tags]                                  AtualizarSA
    Logar no FSL
    Consultar SA
    Preencher Auxilio
    Validar Itens das ordens de trabalho para execucao                              CONSUMO_EQUI=${EQUIPAMENTO}
    Valida inclusao de Materiais e Equipamentos
    Validar Itens das ordens de trabalho apos a execucao
    Encerrar com Sucesso

Encerrar SA com Pendencia 7065
    [Documentation]                         Atualizar e Encerrar o SA com Pendencia 7065
    [Tags]                                  AtualizarSAPendencia7065
    Logar no FSL
    Consultar SA
    Encerrar com Pendencia 7065

Atualizar e Encerrar o SA - Retirada
    [Documentation]                         Atualizar e Encerrar o SA sem preencher "Equipamento"
    [Tags]                                  AtualizarEncerrarSARetirada
    Logar no FSL
    Consultar SA
    Preencher Auxilio
    Atualizar Facilidades
    Atualizar Consumo de Equipamento - Equipamento existente
    Atualizar Consumo de Materiais
    Criacao e Validacao do Tecnico Auxiliar
    Encerrar com Sucesso - Retirada
    
Atribuicao do tecnico auxiliar 
    [Documentation]                         Atribuicao do tecnico auxiliar
    [Tags]                                  AtribuicaoTecnicoAuxiliar
    Logar no FSL
    Consultar SA
    Criacao e Validacao do Tecnico Auxiliar

    
Atualizar e Encerrar o SA - Bitstream
    [Arguments]                             ${EQUIPAMENTO}
    [Documentation]                         Atualizar e Encerrar o SA com preenchimento de equipamentos,materias, facilidades e tecnico
    ...                                     | =Arguments= | =Description= |
    ...                                     | `EQUIPAMENTO` | Equipamento que será selecionado durante o encerramento no FSL |
    [Tags]                                  AtualizarEncerrarSARetiradaBitstream
    Logar no FSL
    Consultar SA
    Preencher Auxilio
    Validar Itens das ordens de trabalho para execucao                              CONSUMO_EQUI=${EQUIPAMENTO}
    Valida inclusao de Materiais e Equipamentos
    Validar Itens das ordens de trabalho apos a execucao

Valida sucesso do equipamento no FSL
    [Documentation]                         Valida no FSL se o equipamento está com SUCESSO e Encerrar no OPM
    Logar no FSL
    Consultar SA
    Valida inclusao de Materiais e Equipamentos
    Validar Itens das ordens de trabalho apos a execucao
    Close Browser                           CURRENT


Atualizar e Encerrar a SA Voip
    [Arguments]                             ${EQUIPAMENTO}
    [Documentation]                         Atualizar e Encerrar o SA com preenchimento de equipamentos,materias, facilidades e tecnico
    ...                                     | =Arguments= | =Description= |
    ...                                     | `EQUIPAMENTO` | Equipamento que será selecionado durante o encerramento no FSL |
    [Tags]                                  AtualizarEncerrarSARetiradaBitstream
    Logar no FSL
    Consultar SA
    Preencher Auxilio
    Validar Itens das ordens de trabalho para execucao                              CONSUMO_EQUI=${EQUIPAMENTO}
    Valida inclusao de Materiais e Equipamentos
    Validar Itens das ordens de trabalho apos a execucao
    Encerrar com Sucesso

Encerrar o SA - Reparo
    [Documentation]                         Encerrar o SA de reparo com o código 40301
    [Tags]                                  EncerrarSAReparoCodigo40301
    Logar no FSL
    Consultar SA
    Criacao e Validacao do Tecnico Auxiliar
    Consultar SA
    Preencher Auxilio
    Encerrar com Sucesso - Reparo
    
#===================================================================================================================================================================
Encerrar a Pendencia do Agendamento
    [Documentation]                         Função usada para encerrar uma pendencia de agendamento usando sistema FSL.

    Logar no FSL
    Consultar SA

    ${complemento_existe}                   Ler Variavel na Planilha                typeComplement1                         Global
    IF    "${complemento_existe}" != "None"
        Scroll By                               vertical=80%
        ${fslComplement}=                       Get Text Element is Visible             //*[text()="Tipo Complemento"]/../..//div[2]//span[@class="uiOutputText"]            
        ${complementType}=                      Ler Variavel na Planilha                typeComplement1                         Global

        Should Be Equal                         ${fslComplement}                        ${complementType}                       Complemento diferente da planilha.
        Scroll By                               vertical=-80%
    END

    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${itens_de_linha}
    ${nrows}=                               Get Element Count is Visible            //*[text()="Informação FTTH"]/../../../..//tr
    IF    ${nrows} != 4
        Fatal Error                         Número de linhas diferente do esperado. 
    END

    ## Adicionando tec. auxiliar
    Consultar SA
    Consultar Acao
    Click Web Element Is Visible            ${btn_criar_tecnico}
    Input Text Web Element Is Visible       ${input_id_tecnico}                     TR746080
    Click Web Element Is Visible            ${btn_salvar_criar}
    Click Web Element Is Visible            ${btn_close_facilidade}

    ## Encerrando
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           10301
    Input Text Web Element Is Visible       ${input_observacao}                     Reparo
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global

    ${Counter}=                             Set Variable                            1
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}
    
    WHILE   "${ESTADO_SITE}" != "Concluído com sucesso"
        Sleep                                   2s
        Reload
        ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}
        
        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e não ficou Concluído com sucesso
        END
    END

#===================================================================================================================================================================
Atualizar e Encerrar com Extravio
    [Documentation]                         Função usada para Atualizar e Encerrar o SA com extravio.
    [Tags]                                  AtualizarSAExtravio

    Logar no FSL
    Consultar SA
    
    Click Web Element Is Visible            ${btn_consumo_equipamento}
    Click Web Element Is Visible            ${check_equipamento}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_avancar}
    Select Options By                       ${input_comodo}                         text                                    Escritório
    Click Web Element Is Visible            ${check_extravio}
    Input Text Web Element Is Visible       ${motivo_extravio}                      Aparelho Extraviado       
    Click Web Element Is Visible            ${btn_avancar}
    Check Checkbox                          ${check_adicionar_mais}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}

    ## Valida Produto Consumido 

    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${produtos_consumidos}
    ${Counter}=                             Set Variable                            1

    ${Quantia_linha}=                       Get Element Count is Visible            ${table_produtos_consumidos}
    IF  "${Quantia_linha}" != "1"
        Fatal Error                         Existem items em excesso.
    END
    
    ########################################
    
    ## Adicionando "Teve Auxílio"

    Consultar SA
    Click Web Element Is Visible            ${btn_editSA}             
    Select Options By                       ${optionAux_editSA}                     text                                    Sim
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}   

    ########################################

    ## Encerrando com Extravio

    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           00
    Input Text Web Element Is Visible       ${input_observacao}                     ENCERRAMENTO RETIRADA COM EXTRAVIO
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    Sleep                                   9s
    Reload
    ########################################
    Close Browser                           CURRENT



#===========================================================================================================================================================================================================
Atualizar Facilidades
    [Documentation]                         Função usada para Atualizar, criando se ela não existir, uma facilidade.
    Consultar SA
    
    Click Web Element Is Visible            ${btn_acao}

    ${count_linhas_facilidade}=             Get Element Count is Visible            ${quantia_linhas_facilidade}

    IF  "${count_linhas_facilidade}" != "1"
        Click Web Element Is Visible            ${btn_criar}
        Input Text Web Element Is Visible       ${cabo_riser}                           1275
        Input Text Web Element Is Visible       ${cabo_drop}                            1274
        Input Text Web Element Is Visible       ${CDOIA}                                1277
        Click Web Element Is Visible            ${btn_salvar_criar}
        Click Web Element Is Visible            ${btn_close_facilidade}
    ELSE
        Log To Console                      Facilidade já adicionada
    END

#===========================================================================================================================================================================================================
Atualizar Consumo de Equipamento
    [Arguments]                             ${EQUIPAMENTO}=ONT INTEGRADA - 617396_ONT 240W-C DUAL BAND NOKIA 2GHZ/5GHZ
    [Documentation]                         Função usada para adicionar um consumo de um equipamento pelo técnico.
    Consultar SA
    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${produtos_consumidos}

    ${Quantia_linha}=                       Get Element Count is Visible            ${table_produtos_consumidos}

    FOR    ${quantia_repet}    IN RANGE     ${Quantia_linha}
        Exit For Loop IF    "${Quantia_linha}" == "2"
        ${quantia_repet}=                   Evaluate                                ${quantia_repet} + 1
        ${produto_adicionado}=              Get Text Element is Visible             (//table[@role='grid'][@aria-label='Produtos consumidos'])//tbody//tr[${quantia_repet}]//td[2]
        IF    "${produto_adicionado}" != "${EQUIPAMENTO}"
            Consultar SA
            Click Web Element Is Visible            ${btn_consumo_equipamento}
            Click Web Element Is Visible            ${check_equipamento}
            Click Web Element Is Visible            ${btn_avancar}
            Click Web Element Is Visible            ${btn_avancar}
            Select Options By                       ${select_equipamento}                   text                                    ${EQUIPAMENTO}
            Gerar Nr de Serie FSL                        
            Input Text Web Element Is Visible       ${input_nr_serie}                       ${nr_serie}
            Select Options By                       ${input_comodo}                         text                                    Cozinha
            Check Checkbox                          ${check_associar}
            Click Web Element Is Visible            ${btn_avancar}
            Check Checkbox                          ${check_adicionar_mais}
            Click Web Element Is Visible            ${btn_avancar}
            Click Web Element Is Visible            ${btn_concluir}
        ELSE
            Log To Console                  \n Equipamento já Adicionado
        END
    END

#===========================================================================================================================================================================================================
Atualizar Consumo de Materiais
    [Documentation]                         Função usada para adicionar um consumo de matériais pelo técnico.
    Consultar SA
    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${produtos_consumidos}

    ${Quantia_linha}=                       Get Element Count is Visible            ${table_produtos_consumidos}

    FOR    ${quantia_repet}    IN RANGE     ${Quantia_linha}
        Exit For Loop IF    "${Quantia_linha}" == "2"
        ${quantia_repet}=                   Evaluate                                ${quantia_repet} + 1
        ${produto_adicionado}=              Get Text Element is Visible             (//table[@role='grid'][@aria-label='Produtos consumidos'])//tbody//tr[${quantia_repet}]//td[2]
        IF    "${produto_adicionado}" != "PARAFUSO C/BUCHA PLASTICA S-6"
            Consultar SA
            Click Web Element Is Visible            ${btn_consumo_equipamento}
            Click Web Element Is Visible            ${check_material}
            Click Web Element Is Visible            ${btn_avancar}
            Click Web Element Is Visible            ${check_adicionar}
            Click Web Element Is Visible            ${btn_avancar}
            Select Options By                       ${input_grupo_material}                 text                                    ACESSÓRIOS
            Click Web Element Is Visible            ${btn_avancar}
            Select Options By                       ${input_material}                       text                                    PARAFUSO C/BUCHA PLASTICA S-6
            Select Options By                       ${input_acao}                           text                                    Adicionar
            Input Text Web Element Is Visible       ${input_quantidade}                     12
            Click Web Element Is Visible            ${btn_avancar}
            Check Checkbox                          ${check_adicionar_mais}
            Click Web Element Is Visible            ${btn_avancar}
            Click Web Element Is Visible            ${btn_concluir}
        ELSE
            Log To Console                  \n Material já Adicionado
        END
    END

#===========================================================================================================================================================================================================
Valida inclusao de Materiais e Equipamentos
    [Documentation]                         Função usada para Validar se após adicionar os Materiais e equipamenetos, o material ficou com OK, evitando erros
    Consultar SA    
    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${produtos_consumidos}
    ${Counter}=                             Set Variable                            1

    Click Web Element Is Visible            ${linha_equipamento}
    ${Validacao_OK}=                        Get Text Element is Visible             ${equipamento_ok}


    WHILE   "${Validacao_OK}" != "OK"
        Reload
        ${Validacao_OK}=                    Get Text Element is Visible             ${equipamento_ok}

        #Contador que espera até 10s para confirmar que ficou OK
        ${Counter}=                         Evaluate                                ${Counter} + 1
        Sleep                               3s
        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e o OK na linha do equipamento não
        END

    END
    
#===========================================================================================================================================================================================================
Criacao e Validacao do Tecnico Auxiliar
    [Documentation]                         Função usada para criar e validar se a criação de um técnico que auxiliou na instação.
    Logar no FSL
    Consultar SA
    Consultar Acao
    Click Web Element Is Visible            ${btn_criar_tecnico}
    Input Text Web Element Is Visible       ${input_id_tecnico}                     TR746080
    Click Web Element Is Visible            ${btn_salvar_criar}
    Click Web Element Is Visible            ${btn_close_facilidade}
    Click Web Element Is Visible            ${btn_exibir_tudo_tec}
    Click Web Element Is Visible            ${btn_tec}
    ${tecnico_id}=                          Get Text Element is Visible             ${tecnico_id}

    IF  "${tecnico_id}" != "TR746080"
        Fatal Error                         ID do Téncico está diferente do esperado
    END

#===========================================================================================================================================================================================================
Encerrar com Sucesso
    [Documentation]                         Função usada para finalizar e validar se a SA foi finalizada e concluída com sucesso.
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           00
    Input Text Web Element Is Visible       ${input_observacao}                     Script VTAL
    ${drop}=                                Run Keyword And Return Status           Select Options By                       ${select_encerramento_drop}             text                                    Não
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    
    ${Counter}=                             Set Variable                            1
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}
    
    WHILE   "${ESTADO_SITE}" != "Concluído com sucesso"
    
        Sleep                                   2s
        Reload
        ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}
        
        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e não ficou Concluído com sucesso
        END
    
    END
    
#===========================================================================================================================================================================================================
Encerrar com Sucesso - Retirada
    [Documentation]                         Função usada para finalizar e validar se a SA usada para a retirada foi finalizada e concluída com sucesso.
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           00
    Input Text Web Element Is Visible       ${input_observacao}                     Retirada
    ${drop}=                                Run Keyword And Return Status           Select Options By                       ${select_encerramento_drop}             text                                    Não
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    WHILE   "${ESTADO_SITE}" != "Concluído com sucesso"
    
        Sleep                                   2s
        Reload
        ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e não ficou Concluído com sucesso
        END

    END

#===========================================================================================================================================================================================================
Encerrar com Sucesso - Reparo
    [Documentation]                         Função usada para finalizar e validar se a SA usada para reparo foi finalizada e concluída com sucesso.
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           40301
    Input Text Web Element Is Visible       ${input_observacao}                     Reparo
    ${drop}=                                Run Keyword And Return Status           Select Options By                       ${select_encerramento_drop}             text                                    Não
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    WHILE   "${ESTADO_SITE}" != "Concluído com sucesso"
    
        Sleep                                   2s
        Reload
        ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e não ficou Concluído com sucesso
        END

    END

#===========================================================================================================================================================================================================

Encerrar com Pendencia 7065
    [Documentation]                         Função usada para finalizar uma SA com pendencia e validar se a SA foi finalizada e concluída com sucesso.
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           7065
    Input Text Web Element Is Visible       ${input_observacao}                     LOCAL FECHADO
    ${drop}=                                Run Keyword And Return Status           Select Options By                       ${select_encerramento_drop}             text                                    Não
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído sem sucesso                   Estado                                  Global
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    WHILE   "${ESTADO_SITE}" != "Concluído sem sucesso"
    
        Sleep                                   2s
        Reload
        ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e não ficou Concluído com sucesso
        END

    END

#===========================================================================================================================================================================================================
Atualizar Consumo de Equipamento - Equipamento existente
    [Documentation]                         Função usada para adicionar equipamentos em uma SA que já tem equipamentos.
    Click Web Element Is Visible            ${btn_consumo_equipamento}
    Click Web Element Is Visible            ${check_equipamento}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_avancar}
    Check Checkbox                          ${check_adicionar_mais}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}

#===========================================================================================================================================================================================================
Preencher Auxilio
    [Documentation]                         Função usada para preencher o Auxilio durante a instalação.
    Click Web Element Is Visible            ${btn_editar_sa}
    Select Options By                       ${select_auxilio}                       text                                    Sim
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}

#===========================================================================================================================================================================================================
Validar Itens das ordens de trabalho apos a execucao
    [Documentation]                         Função usada para validar os itens necessários para instalação
    Consultar SA
    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${itens_linha_trabalho}
    
    ${quantia_itens_linha_trabalho}=        Get Element Count is Visible            ${linhas_itens_ordem_trabalho}
    
    FOR    ${quantia_repet}    IN RANGE     ${quantia_itens_linha_trabalho}
        ${quantia_repet}=                   Evaluate                                ${quantia_repet} + 1
        ${return_obrigatorio}=              Get Property With Specific Element is Visible                                   (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[${quantia_repet}]//img                           alt
        
        IF    ${return_obrigatorio}
            ${status_ordem_trabalho}=       Get Text Element is Visible              (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[${quantia_repet}]//span[contains(.,'Completed')]//span
            IF  "${status_ordem_trabalho}" != "Completed"
                Fatal Error                 \nUma das Atividades não ficou com o status Completed
            END
        END
    END

#===========================================================================================================================================================================================================
Validar Itens das ordens de trabalho para execucao
    [Documentation]                         Função usada para validar os itens necessários para instalação
    ...                                     | =Arguments= | =Description= |
    ...                                     | `CONSUMO_EQUI` | Equipamento que será selecionado durante o encerramento no FSL |
    ...                                     | Exemplos de equipamentos: |
    ...                                     | ONT INTEGRADA_617617_HG8145-V5 HUAWEI 2GHZ E 5GHZ |
    ...                                     | ONT CP1 HUAWEI 2GHZ E 5GHZ |
    ...                                     | 700131 - ONT TIM SAGEM FAST5670 WI-FI 6 |
    [Arguments]                             ${CONSUMO_EQUI}=ONT INTEGRADA_617617_HG8145-V5 HUAWEI 2GHZ E 5GHZ

    Consultar SA
    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${itens_linha_trabalho}
    
    ${quantia_itens_linha_trabalho}=        Get Element Count is Visible            ${linhas_itens_ordem_trabalho}
    @{KW_to_execute}=                       Create List

    ${numero_ordem_lista}=                  Get Text Element is Visible             ${numero_orden_lista_get} 

    IF    "${numero_ordem_lista}" != "00000001"
        Click Web Element Is Visible        ${numero_linha_ordem_trabalho}
    END
    

    FOR    ${quantia_repet}    IN RANGE     ${quantia_itens_linha_trabalho}
        ${quantia_repet}=                   Evaluate                                ${quantia_repet} + 1
        ${return_obrigatorio}=              Get Property With Specific Element is Visible                                   (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[${quantia_repet}]//img                           alt
        
        IF    ${return_obrigatorio}
            ${tipo_ordem_trabalho}=         Get Text Element is Visible             (//table[@role='grid'][@aria-label='Itens de linha da ordem de trabalho'])//tbody//tr[${quantia_repet}]//td[2]//span//span
            Append To List                  ${KW_to_execute}                        ${tipo_ordem_trabalho}
        END
    END

    FOR    ${KW_list}    IN    @{KW_to_execute}
        Run Keyword If                      "${KW_list}" == "Técnico Auxiliar"             Criacao e Validacao do Tecnico Auxiliar
        Run Keyword If                      "${KW_list}" == "Informação FTTH"              Atualizar Facilidades
        Run Keyword If                      "${KW_list}" == "Consumo de Material"          Atualizar Consumo de Materiais
        IF  "${CONSUMO_EQUI}" == "ONT INTEGRADA - 617396_ONT 240W-C DUAL BAND NOKIA 2GHZ/5GHZ"
            Run Keyword If                  "${KW_list}" == "Consumo de Equipamento"       Atualizar Consumo de Equipamento
        ELSE
            Run Keyword If                  "${KW_list}" == "Consumo de Equipamento"       Atualizar Consumo de Equipamento      EQUIPAMENTO=${CONSUMO_EQUI}
        END
    
    END
    
#===========================================================================================================================================================================================================
Validar Hierarquia da Atividade e Gestão de Polígonos
    [Documentation]                         Função usada para validar Hierarquia da Atividade e Gestão de Polígonos
    Logar no FSL
    BuiltIn.Sleep                           5
    
    #Pagina da SA, clica no botão relacionado e salva na planilha o tecnico atribuido na SA finalizada.
    Click Web Element Is Visible            ${btn_relacionado}
    Sleep                                   3s
    ${nome_tecnico}=                        Get Text Element is Visible             ${nome_tecnico_atribuido}
    Escrever Variavel na Planilha           ${nome_tecnico}                         Tecnico_Associado                       Global
    
    #Faz a pesquisa do Recurso de Serviço no botão iniciar
    Sleep                                   2s
    Click Web Element Is Visible            ${btn_iniciador}
    Click Web Element Is Visible            ${btn_visualizar_tudo}
    Scroll To Element                       ${btn_Recurso_servicos}
    Click Web Element Is Visible            ${btn_Recurso_servicos}
    
    #Pesquisa e clica no link do tecnico associado.
    Sleep                                   2s
    Input Text Web Element Is Visible       ${button_Pesquisa_Lista}                ${nome_tecnico}
    Click Web Element Is Visible            ${button_Refresh_Lista}
    Click Web Element Is Visible            xpath=//th[@scope='row']//a[@title='${nome_tecnico}']
    Click Web Element Is Visible            ${pg_Relacionado}
    
    #Valida se o territorio_servico está como "(1)"
    Sleep                                   5s
    Scroll To Element                       ${local_territorio_servico}
    Sleep                                   3s
    Get Text Element is Visible Valida      ${valida_1_territorio}                  ==                                      (1)
    Close Browser                           CURRENT

#===================================================================================================================================================================
Encerrar SA Bitstream
    [Documentation]                         Função usada para finalizar e validar se a SA foi finalizada e concluída com ou sem sucesso.
    [Arguments]                             ${COD_ENCERRAMENTO}                     ${MOTIVO_ENCERRAMENTO}                  ${STATUS_ENCERRAMENTO}
                        
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           ${COD_ENCERRAMENTO}
    Sleep                                   3s
    Click Web Element Is Visible            ${button_pesquisar}
    Input Text Web Element Is Visible       ${input_observacao}                     ${MOTIVO_ENCERRAMENTO} 
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           ${STATUS_ENCERRAMENTO}                  Estado                                  Global
    
    ${Counter}=                             Set Variable                            1

    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    IF    "${STATUS_ENCERRAMENTO}" == "Concluído sem sucesso"
        WHILE   "${ESTADO_SITE}" != "Concluído sem sucesso"
        
            Sleep                           2s
            Reload
            ${ESTADO_SITE}=                 Get Text Element is Visible         ${estado_item}

            IF  "${Counter}" == "25" 
                Fatal Error                 \nSe passou muito tempo e não ficou Concluído sem sucesso
            END
        END
        Close Browser                       CURRENT
    
    ELSE IF    "${STATUS_ENCERRAMENTO}" == "Concluído com sucesso"
        WHILE   "${ESTADO_SITE}" != "Concluído com sucesso"
        
            Sleep                           2s
            Reload
            ${ESTADO_SITE}=                 Get Text Element is Visible         ${estado_item}

            IF  "${Counter}" == "25" 
                Fatal Error                 \nSe passou muito tempo e não ficou Concluído com sucesso
            END
        END
        Close Browser                       CURRENT
    
    ELSE
        Fatal Error                         \nStatus Encerramento inválido para validação.
    END
#===================================================================================================================================================================
Atualizar e Encerrar sem Extravio
    [Documentation]                         Função usada para Atualizar e Encerrar o SA sem extravio.
    [Tags]                                  AtualizarSASemExtravio

    Logar no FSL
    Consultar SA
    Preencher Auxilio
    Validar Itens das ordens de trabalho para execucao

    #consumo de equipamentos
    Consultar SA
    Click Web Element Is Visible            ${btn_consumo_equipamento}
    Click Web Element Is Visible            ${check_equipamento}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_avancar}  
    Click Web Element Is Visible            ${btn_avancar}
    Check Checkbox                          ${check_adicionar_mais}
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}

    ## Valida Produto Consumido 
    Click Web Element Is Visible            ${ordem_trabalho}
    Click Web Element Is Visible            ${produtos_consumidos}
    ${Counter}=                             Set Variable                            1

    ${Quantia_linha}=                       Get Element Count is Visible            ${table_produtos_consumidos}
    IF  "${Quantia_linha}" != "1"
        Fatal Error                         Existem items em excesso.
    END

    ## Encerrando sem Extravio
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Input Text Web Element Is Visible       ${input_code}                           00
    Input Text Web Element Is Visible       ${input_observacao}                     Retirada com sucesso
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    Sleep                                   9s
    Reload
    Close Browser                           CURRENT

#===========================================================================================================================
Encerrar SA com Sucesso via SOM
    [Arguments]                             ${codigoEquipamento}
    ...                                     ${nomeTecAuxiliar}
    ...                                     ${VALOR_PESQUISA}=associatedDocument
    
    Login SOM

    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                ${VALOR_PESQUISA}                       Global
    Pesquisa Tarefa no SOM                  VALOR_PESQUISA=associatedDocument       TASK_NAME=T046 - Associar Equipamento - Manual

    # CLICA NOS 3 PONTOS DA TAREFA
    Click Web Element Is Visible            //td[normalize-space()="T046 - Associar Equipamento - Manual" and //td[normalize-space()="${VALOR_PESQUISA}"]]/..//input[contains(@name,'move')]

    Gerar Nr de Serie
    Input Text Web Element Is Visible       ${inputNumeroSerie}                     ${nr_serie}
    Input Text Web Element Is Visible       ${inputCodigoEquipamento}               ${codigoEquipamento}
    Click Web Element Is Visible            ${lupaEquipamento}
    
    # MUDA A PÁGINA E SELECIONA O EQUIPAMENTO
    Switch Page                             NEW
    Click Web Element Is Visible            //td[normalize-space()='${codigoEquipamento}']/..//input[@class='button']

    # ATUALIZA O STATUS
    Switch Page                             CURRENT
    Select Element is Visible               ${selectStatus}                         Sucesso
    Click Web Element Is Visible            ${btnUpdate}
    
    Sleep                                   3s
    Pesquisa Tarefa no SOM                  TASK_NAME=T017 - Instalar Equipamento
    
    Right Click Web Element Is Visible      //td[normalize-space()="T017 - Instalar Equipamento" and //td[normalize-space()="${VALOR_PESQUISA}"]]/..//input[contains(@name,'move')]
    Click Web Element Is Visible            //span[contains(.,'Change Task State/Status')]

    # ASSOCIA AO USUÁRIO
    ${tr_usuario_som}                       Convert To Lowercase                    ${usuario_som}
    Select Element is Visible               ${selectUsuarios}                       ${tr_usuario_som}
    Click Web Element Is Visible            ${radioBtnAssociar}
    Click Web Element Is Visible            ${inputUpdateAssociar}
    
    Pesquisa Tarefa no SOM                  TASK_NAME=T017 - Instalar Equipamento
    Click Web Element Is Visible            //td[normalize-space()="T017 - Instalar Equipamento" and //td[normalize-space()="${VALOR_PESQUISA}"]]/..//input[contains(@name,'move')]

    # PREENCHE O ENCERRAMENTO
    Input Text Web Element Is Visible       ${inputMatriculaTecnico}                ${usuario_som}
    Input Text Web Element Is Visible       ${inputCodigoEncerramento}              00000
    Input Text Web Element Is Visible       ${inputObservacoesBA}                   Encerramento com Sucesso

    # ADICIONA TECNICO AUXILAR
    Click Web Element Is Visible            ${addTecnicoAuxiliar}
    Input Text Web Element Is Visible       ${inputNomeTecnicoAux}                  ${nomeTecAuxiliar}
    Input Text Web Element Is Visible       ${inputMatriculaTecnicoAux}             ${usuario_som}

    Select Element is Visible               ${selectStatus}                         Sucesso
    Click Web Element Is Visible            ${btnUpdate}

    Sleep                                   3s
    Close Browser                           CURRENT


#===========================================================================================================================
Encerrar SA Voip
    [Documentation]                         Função usada para finalizar e validar se a SA foi finalizada e concluída com sucesso.
    
    Consultar SA
    Click Web Element Is Visible            ${btn_encerrar}
    Input Text Web Element Is Visible       ${input_rsr}                            999999
    Click Web Element Is Visible            ${arvore_codigos}
    Input Text Web Element Is Visible       ${input_code}                           00
    Click Web Element Is Visible            ${button_pesquisar}
    Select Options By                       ${arvore_codigo1}                       text                                    Todos os produtos
    Select Options By                       ${arvore_codigo2}                       text                                    Plat.Ext.(HC)-Amb. Cli - ONT
    Select Options By                       ${arvore_codigo3}                       text                                    Outros - Substituído
    Input Text Web Element Is Visible       ${input_observacao}                     Encerramento Reparo
    Click Web Element Is Visible            ${btn_avancar}
    Click Web Element Is Visible            ${btn_concluir}
    Escrever Variavel na Planilha           Concluído com sucesso                   Estado                                  Global
    
    ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}

    ${Counter}=                             Set Variable                            1
    WHILE   "${ESTADO_SITE}" != "Concluído com sucesso"
    
        Sleep                                   2s
        Reload
        ${ESTADO_SITE}=                         Get Text Element is Visible             ${estado_item}
        
        IF  "${Counter}" == "25" 
            Fatal Error                     \nSe passou muito tempo e não ficou Concluído com sucesso
        END
    
    END
