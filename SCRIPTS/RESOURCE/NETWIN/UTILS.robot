*** Settings ***
Library                                     String
Library                                     Collections
Library                                     Browser
Library                                     Dialogs
Library                                     DateTime
Library                                     ../../RESOURCE/COMMON/LIB/lib_geral.py

Resource                                    ../../RESOURCE/API/RES_API.robot
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/NETWIN/PAGE_OBJECTS.robot
Resource                                    ../../RESOURCE/NETWIN/VARIABLES.robot

*** Variables ***
${IDSurvey}
${numero_calcada}

*** Keywords ***

Logar Netwin 
    [TAGS]                                  LoginNetwin
    [Documentation]                         Faz Login no Netwin
    ...                                     \nPreenche dados de login com usuário e senha da planilha e inserir a mensagem do captcha fixa.

    ${Usuario_Netwin}=                      Ler Variavel Param Global               $.Logins.NETWIN.Usuario                          
    ${Senha_Netwin}=                        Ler Variavel Param Global               $.Logins.NETQ.Senha                            
    ${URL_NETWIN}=                          Ler Variavel Param Global               $.Urls.NETWIN                              
    Contexto para navegador                 ${URL_NETWIN}                           Navegador=chromium
    Wait for Elements State                 ${btn_login_Netwin}                     Visible                                 timeout=${timeout}

    Input Text Web Element Is Visible       ${input_login_Netwin}                   ${Usuario_Netwin}
    Input Text Web Element Is Visible       ${input_password_Netwin}                ${Senha_Netwin}
    
    
    Input Text Web Element Is Visible       ${input_captcha_netwin}                 abadia            
    Click Web Element Is Visible            ${btn_login_Netwin}

#==================================================================================================================================================================
Localizar IDSurvey
    [Documentation]                         Tela de pesquisa do CEP no Netwin 
    ...                                      \n clica no campo "location_manager" e depois no "pesquisa", consulta pelo IDSurvey do CEP.
    ...                                     Tendo uma pausa no script para fazer a alteração do CEP e assim encerrando o script.

    Click Web Element Is Visible            ${location_manager} 
    Sleep                                   5s
    Click Web Element Is Visible            ${pesquisa_pg1}
    
    ${IDSurvey}=                            Ler Variavel na Planilha                IDSurvey                                Global

    Input Text Web Element Is Visible       ${Nome_IDSurvey}                        ${IDSurvey}  
    Click Web Element Is Visible            ${pesquisar_IDSurvey}
    Sleep                                   5s
    
    #Clica na Antena na pagina de localizar o Survey
    Click Web Element Is Visible            ${botton_antena}

    ${Timeou_Netwin} =                      Set Browser Timeout                     2m 30 seconds
    Set Browser Timeout                     ${Timeou_Netwin}

    Switch Page                             NEW
    Sleep                                   5s
    
    Pause Execution                         Clique no OK quando o mapa carregar
    #Clica no botão + da pagina do mapa
    Click Web Element Is Visible            ${btn_mais_mapa}
    Click Web Element Is Visible            ${btn_mapa_Redefixa}
    Click Web Element Is Visible            ${btn_mapa_equipamento}
    Click Web Element Is Visible            ${btn_mapa_Survey}
    Click Web Element Is Visible            ${btn_mapa_celulas}
    Sleep                                   2s
    Click Web Element Is Visible            ${botton_lupa}
    Pause Execution                         Clique no CDOE que o Survey está localizado e faça o processo de abastecer e desabastecer após isso clique no OK. 
    Close Browser                           CURRENT

#===================================================================================================================================================================
Ativar Serviço Agregado Ethernet
    [Documentation]                         Ativa Serviço Agregado Ethernet

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}

    Click Web Element Is Visible            ${botao_criar}

    Gerar Nr de Serie
    Input Text Web Element Is Visible       ${ID_externo}                           ${nr_serie}
    Escrever Variavel na Planilha           ${nr_serie}                             numeroSerie                             Global
    Click Web Element Is Visible            ${data_objetivo}
    Click Web Element Is Visible            ${selecionar_data_atual}

    Click Web Element Is Visible            ${adicionar_servico}
    Select Options By                       ${selecionar_servico}                   value                                   CFS.TC_IP_CONNECT
    Select Options By                       ${operacao_adicionarServico}            value                                   ACTIVAR
    Input Text Web Element Is Visible       ${campoNome_adicionarServico}           ${nr_serie}
    Select Options By                       ${unidadeDebito_adicionarServico}       value                                   Mbps
    Click Web Element Is Visible            ${botao_adicionar_adicionarServico}
    Click Web Element Is Visible            ${botao_confirmar}

    ${CURRENT_CONTEXT}=                     Get Page Ids
    Log                                     ${CURRENT_CONTEXT}

    # Click Web Element Is Visible            ${botao_ok}                             #Confirma submeter serviço sem associar um cliente
    Click Web Element Is Visible            ${botao_ok}                             #Confirma visualizar ordem criada no RP

    # Nova janela do Netwin - Fazer validações e Criação de Atribuição
    Switch Page                             NEW
    Sleep                                   5s
    
    Validar Abas
    Criacao de Atribuicao                   TDM Nx64
    
    Close Browser                           CURRENT

#===================================================================================================================================================================
Consultar Viabilidade Netwin
    [Arguments]                             ${MASSA}=1
    ...                                     ${TENTATIVAS_FOR}=5
    [Documentation]                         Consulta Viabilidade do endereço pelo Netwin.
    ...                                     \nCaso haja complemento, colocar o tipo por extenso na planilha (Ex.: LJ -> LOJA)
    ...                                     \nARGUMENTO UTILIZADO EM CENÁRIOS QUE REQUEREM MAIS DE 1 MASSA.
    ...                                     | `MASSA` | Massa que será utilizada. Valores esperados: "1" ou "2" |
    ...                                     | `TENTATIVAS_FOR` | Quantas tentativas devem ser realizadas. Se não for passado argumento, por padrão, será usado " 5 " |
    
    # VERIFICA QUAL O CEP VAI SER USADO (PARA CENÁRIOS QUE UTILIZAM 2 MASSAS)
    IF    "${MASSA}" == "1"
        ${CEP}=                             Ler Variavel na Planilha                Address                                 Global
        ${numero_fachada}=                  Ler Variavel na Planilha                Number                                  Global
    
        # Consulta a API e escreve na planilha os valores de UF, Bairro e Código de Localidade
        Retornar Token Vtal
        ${Response}=                        GET_API                                 ${API_BASEGEOGRAPHICADDRES}/geographicAddress?address=${CEP}&number=${numero_fachada}

        ${uf_logradouro}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].stateAbbreviation
        ${bairro_logradouro}=               Get Value From Json                     ${Response.json()}                      $.addresses.address[0].neighborhood
        ${codigo_localidade}=               Get Value From Json                     ${Response.json()}                      $.addresses.address[0].locationCode
        ${state_logradouro}=                Get Value From Json                     ${Response.json()}                      $.addresses.address[0].state
        
        ${estado_maiusculo}=                Convert To Uppercase                    ${state_logradouro[0]}

        
        Escrever Variavel na Planilha       ${uf_logradouro[0]}                     UF                                      Global
        Escrever Variavel na Planilha       ${bairro_logradouro[0]}                 Bairro                                  Global
        Escrever Variavel na Planilha       ${codigo_localidade[0]}                 locationCode                            Global

        Logar Netwin

        # PREENCHE OS CAMPOS E FAZ A CONSULTA
        Click Web Element Is Visible            ${resource_provisioning}
        Click Web Element Is Visible            ${viabilidade_GPON}

   
        FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}


            Select Element is Visible               ${select_segmento}              Residencial
            Input Text Web Element Is Visible       ${input_CEP}                    ${CEP}
            Keyboard Key                            press                           Enter
            Sleep                                   5s

            # SE O CEP POSSUIR MAIS DE 1 BAIRRO, VALIDA SE A TABELA APARECE NA TELA
            ${estados}                      Get Element States                      ${popUp_tabela}
            ${response_Widget}              Run Keyword And Return Status           Wait For Elements State                 ${popUp_tabela}                         attached                                5
            ${indice}                       Evaluate                                ${x} + 1
            
            # CASO APAREÇA, SELECIONA O BAIRRO (COMEÇANDO PELO PRIMEIRO)
            IF    ${response_Widget} == True
                ${quantidade_linhas}        Get Element Count                       ${widget_tabelaCEP}
                IF    ${indice} > ${quantidade_linhas}
                    Fatal Error             \nNão há mais bairros a serem verificados
                    BREAK
                END
                ${bairro_tabela}            Get Text                                ${widget_tabelaCEP}\[@id='${x}']//td\[@id='bairro${x}']
                Log To Console              \n${bairro_tabela}
                Check Checkbox              ${btn_bairro}\[@value='${x}']
                Click Web Element Is Visible                                        ${btn_confirmar_widget}
            END

            # VALIDA SE O SELECT UF ESTÁ PREENCHIDO CORRETAMENTE
            ${UF_valida}=                   Get Selected Options                    ${select_UF}                            label
            ${status_comparacao}=           Run Keyword And Return Status           Should Be Equal As Strings              ${UF_valida}                            ${uf_logradouro[0]} - ${estado_maiusculo}
            
            # CASO NÃO ESTEJA, RECARREGA A PÁGINA
            IF    ${status_comparacao} != True
                Reload
                IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error                 \nO campos automáticos não foram preenchidos corretamente
                END
            
            ELSE
                Input Text Web Element Is Visible       ${input_fachada}                        ${numero_fachada}

                ${tipo_complemento}=        Ler Variavel na Planilha                typeComplement1                         Global
                ${valor_complemento}=       Ler Variavel na Planilha                value1                                  Global
                
                # CASO NÃO TENHA COMPLEMENTO, SELECIONA O VALOR 'XX'
                IF    "${valor_complemento}" == "None"
                    Select Element is Visible           ${select_complemento}                   XX
                    Click Web Element Is Visible        ${btn_validar_viabilidade}
                ELSE
                    Select Element is Visible           ${select_complemento}                   ${tipo_complemento}
                    Input Text Web Element Is Visible    ${input_complemento}                   ${valor_complemento}
                    Click Web Element Is Visible        ${btn_validar_viabilidade}
                END
            END
        

            # QUANDO A TABELA ESTIVER VISÍVEL, VALIDA A VIABILIDADE DO ENDEREÇO E EXTRAI O ID
            Wait For Elements State                 ${tabela_CEP}                   visible
            ${ID_endereco}                          Get Text                        ${tabela_ID_endereco}
            Escrever Variavel na Planilha           ${ID_endereco}                  idEndereco                              Global
            ${status_elemento}                      Get Text                        ${tabela_CEP}


            IF    "${status_elemento}" == "0 - Viável - Viabilidade técnica confirmada"
                Log To Console              \nViabilidade técnica confirmada
                BREAK
            ELSE IF    "${status_elemento}" == "1 - Inviável - Endereço não encontrado"
                Log To Console              \nBairro incorreto, testando o próximo
                Reload
                IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error
                END
            ELSE
                Fatal Error                 \nEndereço inviável
                BERAK
            END
        END
        Close Browser                       CURRENT


    ELSE IF    "${MASSA}" == "2"
        ${CEP}=                             Ler Variavel na Planilha                Address_2                               Global
        ${numero_fachada}=                  Ler Variavel na Planilha                Number_2                                Global
    
        # Consulta a API e escreve na planilha os valores de UF, Bairro e Código de Localidade
        Retornar Token Vtal
        ${Response}=                        GET_API                                 ${API_BASEGEOGRAPHICADDRES}/geographicAddress?address=${CEP}&number=${numero_fachada}

        ${uf_logradouro}=                   Get Value From Json                     ${Response.json()}                      $.addresses.address[0].stateAbbreviation
        ${bairro_logradouro}=               Get Value From Json                     ${Response.json()}                      $.addresses.address[0].neighborhood
        ${codigo_localidade}=               Get Value From Json                     ${Response.json()}                      $.addresses.address[0].locationCode
        ${state_logradouro}=                Get Value From Json                     ${Response.json()}                      $.addresses.address[0].state
        
        ${estado_maiusculo}=                Convert To Uppercase                    ${state_logradouro[0]}

        
        Escrever Variavel na Planilha           ${uf_logradouro[0]}                 UF_2                                    Global
        Escrever Variavel na Planilha           ${bairro_logradouro[0]}             Bairro_2                                Global
        Escrever Variavel na Planilha           ${codigo_localidade[0]}             locationCode_2                          Global

        Logar Netwin

        # PREENCHE OS CAMPOS E FAZ A CONSULTA
        Click Web Element Is Visible            ${resource_provisioning}
        Click Web Element Is Visible            ${viabilidade_GPON}
        Select Element is Visible               ${select_segmento}                  Residencial
        Input Text Web Element Is Visible       ${input_CEP}                        ${CEP}
        Keyboard Key                            press                               Enter
        Sleep                                   5s
        
        FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}

            Select Element is Visible               ${select_segmento}              Residencial
            Input Text Web Element Is Visible       ${input_CEP}                    ${CEP}
            Keyboard Key                            press                           Enter
            Sleep                                   5s

            # SE O CEP POSSUIR MAIS DE 1 BAIRRO, VALIDA SE A TABELA APARECE NA TELA
            ${estados}                      Get Element States                      ${popUp_tabela}
            ${response_Widget}              Run Keyword And Return Status           Wait For Elements State                 ${popUp_tabela}                         attached                                5
            ${indice}                       Evaluate                                ${x} + 1
            
            # CASO APAREÇA, SELECIONA O BAIRRO (COMEÇANDO PELO PRIMEIRO)
            IF    ${response_Widget} == True
                ${quantidade_linhas}        Get Element Count                       ${widget_tabelaCEP}
                IF    ${indice} > ${quantidade_linhas}
                    Fatal Error             \nNão há mais bairros a serem verificados
                    BREAK
                END
                ${bairro_tabela}            Get Text                                ${widget_tabelaCEP}\[@id='${x}']//td\[@id='bairro${x}']
                Log To Console              \n${bairro_tabela}
                Check Checkbox              ${btn_bairro}\[@value='${x}']
                Click Web Element Is Visible                                        ${btn_confirmar_widget}
            END

            # VALIDA SE O SELECT UF ESTÁ PREENCHIDO CORRETAMENTE
            ${UF_valida}=                   Get Selected Options                    ${select_UF}                            label
            ${status_comparacao}=           Run Keyword And Return Status           Should Be Equal As Strings              ${UF_valida}                            ${uf_logradouro[0]} - ${estado_maiusculo}
            
            # CASO NÃO ESTEJA, RECARREGA A PÁGINA
            IF    ${status_comparacao} != True
                Reload
                IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error                 \nO campos automáticos não foram preenchidos corretamente
                END
            
            ELSE
                Input Text Web Element Is Visible       ${input_fachada}                        ${numero_fachada}

                ${tipo_complemento}=        Ler Variavel na Planilha                typeComplement1_2                       Global
                ${valor_complemento}=       Ler Variavel na Planilha                value1_2                                Global
                
                # CASO NÃO TENHA COMPLEMENTO, SELECIONA O VALOR 'XX'
                IF    "${valor_complemento}" == "None"
                    Select Element is Visible           ${select_complemento}                   XX
                    Click Web Element Is Visible        ${btn_validar_viabilidade}
                ELSE
                    Select Element is Visible           ${select_complemento}                   ${tipo_complemento}
                    Input Text Web Element Is Visible    ${input_complemento}                   ${valor_complemento}
                    Click Web Element Is Visible        ${btn_validar_viabilidade}
                END
            END
        

            # QUANDO A TABELA ESTIVER VISÍVEL, VALIDA A VIABILIDADE DO ENDEREÇO E EXTRAI O ID
            Wait For Elements State                 ${tabela_CEP}                   visible
            ${ID_endereco}                          Get Text                        ${tabela_ID_endereco}
            Escrever Variavel na Planilha           ${ID_endereco}                  idEndereco_2                            Global
            ${status_elemento}                      Get Text                        ${tabela_CEP}


            IF    "${status_elemento}" == "0 - Viável - Viabilidade técnica confirmada"
                Log To Console                  \nViabilidade técnica confirmada
                BREAK
            ELSE IF    "${status_elemento}" == "1 - Inviável - Endereço não encontrado"
                Log To Console                  \nBairro incorreto, testando o próximo
                Reload
                IF    ${x} == ${TENTATIVAS_FOR}-1
                Fatal Error
                END
            ELSE
                Fatal Error                     \nEndereço inviável
                BREAK
            END
        END
        Close Browser                           CURRENT

    ELSE
        Fatal Error                         \nMassa não encontrada (Verifique se o campo MASSA está "1" ou "2")
    END

#===================================================================================================================================================================
Validar Abas
    [Arguments]                             ${dados_rede}=NAO                       ${activo}=NAO
    [Documentation]                         Valida os campos da aba Características.\n
    ...                                     Provisão <Em provisão>, Operacional <Em serviço> e datas atuais.
    ...                                     O argumento ${dados_rede} informa se existem dados a serem validados na aba de rede.

    ${provisao_retorno}=                    Get Text Element is Visible             ${caracteristicas_provisao}
    ${operacional_retorno}=                 Get Text Element is Visible             ${caracteristicas_operacional}
    ${dataCriacao_retorno}=                 Get Text Element is Visible             ${caracteristicas_dataCriacao}
    ${dataActualizacao_retorno}=            Get Text Element is Visible             ${caracteristicas_dataActualizacao}
    ${data}=                                Get Current Date                        result_format=%d-%m-%Y

    
    IF    "${activo}" == "SIM"
        Should Be Equal As Strings              ${provisao_retorno}                 Activo
    ELSE
        Should Be Equal As Strings              ${provisao_retorno}                 Em provisão
    END

    Should Be Equal As Strings              ${operacional_retorno}                  Em Serviço
    Should Be Equal As Strings              ${dataCriacao_retorno}                  ${data}
    Should Be Equal As Strings              ${dataActualizacao_retorno}             ${data}

    # Aba Cliente
    Click Web Element Is Visible            ${aba_Cliente}
    Highlight Elements                      ${tipo_cliente}                         duration=100ms                          width=4px                               color=\#dd00dd                          style=solid

    # Aba Serviços de Rede
    Click Web Element Is Visible            ${aba_ServicosDeRede}

    IF    "${dados_rede}" == "SIM"
        Get Text Element is Visible         ${estado_provisao}
    ELSE
        Highlight Elements                  ${tipo_servicosDeRede}                   duration=100ms                     width=4px                               color=\#dd00dd                          style=solid
    END

    # Aba Serviços de Cliente
    Click Web Element Is Visible            ${aba_ServicosDeCliente}
    Highlight Elements                      ${relacao_servicosDeCliente}            duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    
#===================================================================================================================================================================
Criacao de Atribuicao
    [Documentation]                         Cria atribuição no processo de ativar serviço agregado ethernet no Netwin.
    [Arguments]                             ${tipoEsperado}

    Click Web Element Is Visible            ${aba_atribuicao}
    Select Element is Visible               ${familiaRFS}                           Terminação
    Select Element is Visible               ${tipoRFS}                              ${tipoEsperado}
    Click Web Element Is Visible            ${botao_criarRFS}
    Click Web Element Is Visible            ${botao_terminarDesignacao}
    Click Web Element Is Visible            ${botao_okTerminar}
    Click Web Element Is Visible            ${botao_finalizarPedido}
    Click Web Element Is Visible            ${botao_okFinazarPedido}
    Get Element                             ${alerta_sucesso}

#===================================================================================================================================================================
Consultar Serviço Agregado Ethernet
    [Documentation]                         Consulta serviço agregado Ethernet no Netwin.

    Logar Netwin 
    
    ${n_Serie}=                             Ler Variavel na Planilha                numeroSerie                             Global
    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}

    Select Element is Visible               ${selectTipoServico}                    CN - TC IP CONNECT
    Input Text Web Element Is Visible       ${servicoCliente}                       ${n_Serie}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   3s
    Click Web Element Is Visible            ${search_eye}
    Switch Page                             NEW
    Sleep                                   5s
    Validar Abas                            SIM                                     SIM
    Click Web Element Is Visible            ${aba_atribuicao}
    Get Text Element is Visible             ${estado_rfs}
    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT
#===================================================================================================================================================================
Alterar Serviço Agregado Ethernet
    [Documentation]                         Altera o Serviço Agregado Ethernet e valida abas.

    Logar Netwin 

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}

    Click Web Element Is Visible            ${botao_criar}

    Gerar Nr de Serie
    Input Text Web Element Is Visible       ${ID_externo}                           ${nr_serie}
    Click Web Element Is Visible            ${data_objetivo}
    Click Web Element Is Visible            ${selecionar_data_atual}

    Click Web Element Is Visible            ${adicionar_servico}
    Select Options By                       ${selecionar_servico}                   value                                   CFS.TC_IP_CONNECT
    Select Options By                       ${operacao_adicionarServico}            value                                   ALTERAR   
    ${nr_Serie}=                            Ler Variavel na Planilha                numeroSerie                             Global
    Input Text Web Element Is Visible       ${campoNome_adicionarServico}           ${nr_Serie}
    Click Web Element Is Visible            ${button_pesquisa}
    Select Options By                       ${unidadeDebito_adicionarServico}       value                                   Mbps
    Click Web Element Is Visible            ${botao_adicionar_adicionarServico}
    Click Web Element Is Visible            ${botao_confirmar}

    ${CURRENT_CONTEXT}=                     Get Page Ids
    Log                                     ${CURRENT_CONTEXT}

    Click Web Element Is Visible            ${botao_ok}                             #Confirma submeter serviço sem associar um cliente

    # Nova janela do Netwin - Fazer validações e Criação de Atribuição
    Switch Page                             NEW
    Sleep                                   5s
    
    Validar Abas                            SIM                                     
    Criacao de Atribuicao                   CES ATM Nx64

    Close Page                              CURRENT                                 CURRENT
    Consulta Servico Alterado
    Close Browser                           CURRENT
#===================================================================================================================================================================
Consulta Servico Alterado
    [Documentation]                         Consulta o serviço na tela "Resource Provisioning" e valida a alteração concluídas. 

    Click Web Element Is Visible            ${button_inicio}
    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}
    ${nr_Serie}=                            Ler Variavel na Planilha                numeroSerie                             Global
    Select Element is Visible               ${selectTipoServico}                    Todos
    Input Text Web Element Is Visible       ${servicoCliente}                       ${nr_Serie}
    Click Web Element Is Visible            ${pesquisar_pg2}


    Get Text Element is Visible Valida      ${serviço_cliente}                      ==                                      ${nr_Serie}
    Get Text Element is Visible Valida      ${valida_alterar}                       ==                                      Alterar
    Get Text Element is Visible Valida      ${atividade_item}                       ==                                      Final
    Get Text Element is Visible Valida      ${valida_concluido}                     ==                                      Concluído

#===================================================================================================================================================================
Cessar Servico Agregado Ethernet
    [Documentation]                         Cessa o serviço agregado ethernet no netwin.

    Logar Netwin 

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}

    Click Web Element Is Visible            ${botao_criar}

    Gerar Nr de Serie
    Input Text Web Element Is Visible       ${ID_externo}                           ${nr_serie}
    Click Web Element Is Visible            ${data_objetivo}
    Click Web Element Is Visible            ${selecionar_data_atual}    

    Click Web Element Is Visible            ${adicionar_servico}
    Select Options By                       ${selecionar_servico}                   value                                   CFS.TC_IP_CONNECT
    Select Options By                       ${operacao_adicionarServico}            value                                   CESSAR
    ${nr_Serie}=                            Ler Variavel na Planilha                numeroSerie                             Global
    Input Text Web Element Is Visible       ${campoNome_adicionarServico}           ${nr_serie}
    Click Web Element Is Visible            ${button_pesquisa}
    Click Web Element Is Visible            ${botao_adicionar_adicionarServico}
    Click Web Element Is Visible            ${botao_confirmar}

    Click Web Element Is Visible            ${botao_ok}                             #Confirma submeter serviço sem associar um cliente
    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT
    
    Logar Netwin 
    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}
    ${nr_Serie}=                            Ler Variavel na Planilha                numeroSerie                             Global
    Input Text Web Element Is Visible       ${servicoCliente}                       ${nr_serie}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   3s
    Click Web Element Is Visible            ${cessar_eye}
    Switch Page                             NEW
    Sleep                                   5s
    Validar Abas                            NAO                                     NAO
    Click Web Element Is Visible            ${aba_atribuicao}
    Click Web Element Is Visible            ${botao_finalizarPedido}
    Click Web Element Is Visible            ${fim_pedido}

    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT

    Logar Netwin 

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}
    Input Text Web Element Is Visible       ${servicoCliente}                       ${nr_Serie}
    Click Web Element Is Visible            ${pesquisar_pg2}
    
    Sleep                                   3s

    Get Text Element is Visible Valida      ${serviço_cliente}                      ==                                      ${nr_Serie}
    Get Text Element is Visible Valida      ${valida_cessar}                        ==                                      Cessar
    Get Text Element is Visible Valida      ${atividade_item}                       ==                                      Final
    Get Text Element is Visible Valida      ${valida_concluido}                     ==                                      Concluído

    Close Browser                           CURRENT                                 
#===================================================================================================================================================================
Selecionar Georreferenciada
    Click Web Element Is Visible            ${btn_Outside_plant}
    Click Web Element Is Visible            ${btn_visao_georreferenciada}
    Right Click Web Element Is Visible      ${btn_Ba_BAHIA}
    Click Web Element Is Visible            ${btn_pesquisar_geo}

    ${Address}=                             Ler Variavel na Planilha                Address                                 Global
    ${Number}=                              Ler Variavel na Planilha                Number                                  Global
    ${Number_Alteração}=                    Ler Variavel na Planilha                Number_Alteração                        Global
    # ${position_x}=                          Ler Variavel na Planilha                X                                       Global
    # ${position_y}=                          Ler Variavel na Planilha                Y                                       Global
    Set Global Variable                     ${Address}
    Set Global Variable                     ${Number}
    Set Global Variable                     ${Number_Alteração}
    # Set Global Variable                     ${position_x}
    # Set Global Variable                     ${position_y}

#===================================================================================================================================================================
Pesquisar Elemento
    [Documentation]                         Tela de pesquisa do CEP no Netwin 
    ...                                      \n clica no campo "location_manager" e depois no "pesquisa", consulta pelo IDSurvey do CEP.
    ...                                     Tendo uma pausa no script para fazer a alteração do CEP e assim encerrando o script.
    
    [Arguments]                             ${Elemento_UF}=BA - BAHIA
    ...                                     ${Elemento_Municio}=FEIRA DE SANTANA
    ...                                     ${Elemento_Localidade}=FSA - FEIRA DE SANTANA
    ...                                     ${Elemento_Entidade}=Equipamento
    ...                                     ${Elemento_Tipo}=OPT
    ...                                     ${Elemento_Nome}=1

    Click Web Element Is Visible            ${btn_pesquisa_arvore}
    Sleep                                   3s
    Select Element is Visible               ${select_UF_estado}                     ${Elemento_UF}
    Sleep                                   3s
    Select Element is Visible               ${select_Municipio}                     ${Elemento_Municio}
    Sleep                                   3s
    Select Element is Visible               ${select_Localidade}                    ${Elemento_Localidade}
    Sleep                                   3s
    Select Element is Visible               ${select_Entidade}                      ${Elemento_Entidade}
    Sleep                                   3s
    Select Element is Visible               ${select_Tipo}                          ${Elemento_Tipo}
    Sleep                                   3s
    Input Text Web Element Is Visible       ${input_Nome}                           ${Elemento_Nome}
    Sleep                                   3s
    Click Web Element Is Visible            ${btn_pesquisar_Netwin}
    Click Web Element Is Visible            ${btn_OPTN1}

    IF    "${Elemento_Nome}" == "1"
        Click Web Element Is Visible        ${span_close_GOVS}
    END

    Click Web Element Is Visible            ${btn_mais_mapa}
    Click Web Element Is Visible            ${btn_mapa_Redefixa}
    Click Web Element Is Visible            ${btn_mapa_equipamento}
    Click Web Element Is Visible            ${btn_mapa_Survey}
    Click Web Element Is Visible            ${btn_mapa_celulas}

#===================================================================================================================================================================
Selecionar Calçada
    Click Web Element Is Visible            ${btn_caneta+}
    Click Web Element Is Visible            ${btn_caneta+_local}
    Click Web Element Is Visible            ${span_caixa_subterrania}
    Click Web Element Is Visible            ${caixa_calçada}
    Sleep                                   3s
    Pause Execution                         Clique em ok se o quadrado CS-${numero_calcada} foi criado

#===================================================================================================================================================================
Criar Quadrado
    Click Web Element Is Visible            ${select_Projeto}
    Input Text Web Element Is Visible       ${input_projeto}                        TESTE 1
    Click Web Element Is Visible            ${input_projeto_click}
    
    ${atual_date}=                          Get Current Date                        result_format=%Y-%m-%d
    Input Text Web Element Is Visible       ${input_data_caixa}                     ${atual_date}
    
    ${numero_calcada}=                      Get Attribute                           ${input_valor_numero_calcada}           value
    Set Global Variable                     ${numero_calcada}
    
    Click Web Element Is Visible            ${capacidade_click_options}
    Input Text Web Element Is Visible       ${capacidade_input_options}             4
    Click Web Element Is Visible            ${capacidade_input_escolha}

    Sleep                                   3s
    Click Web Element Is Visible            ${tipo_click_options}
    ${xey}=                                 Get BoundingBox                         ${tipo_input_options}
    Input Text Web Element Is Visible       ${tipo_input_options}                   I4 (2,9 x 1,5 x 3)
    Click Web Element Is Visible            ${tipo_input_escolha}

    Sleep                                   3s
    Click Web Element Is Visible            ${material_click_options}
    Input Text Web Element Is Visible       ${material_input_options}               Desconhecido
    Click Web Element Is Visible            ${material_input_escolha}

    Click Web Element Is Visible            ${btn_localizacao}
    Click Web Element Is Visible            ${btn_localizacao_add}

    Click Web Element Is Visible            ${filtro_logradouro_escolha}
    Input Text Web Element Is Visible       ${filtro_logradouro_input_options}      ${Address}
    Click Web Element Is Visible            ${filtro_logradouro_input_escolha}

    Sleep                                   3s
    Input Text Web Element Is Visible       ${input_numero_fachada}                 ${Number}

    Click Web Element Is Visible            ${cep_input_escolha}
    Click Web Element Is Visible            ${cep_input_escolha}

    Click Web Element Is Visible            ${bairro_input_escolha}
    Click Web Element Is Visible            ${bairro_input_escolha}

    Click Web Element Is Visible            ${btn_confirmar_endereço}

    ${Quantia_linha}=                       Get Element Count is Visible            ${linhas_endereço}
    IF  "${Quantia_linha}" != "1"
        Fatal Error                         Existe mais de um endereço para essa caixa
    END

    Click Web Element Is Visible            ${btn_relaçoes}
    Click Web Element Is Visible            ${btn_atividades}
    Click Web Element Is Visible            ${btn_historicos}

    Click Web Element Is Visible            ${btn_origem_escolha}
    Input Text Web Element Is Visible       ${btn_origem_options}                   Netwin
    Click Web Element Is Visible            ${btn_origem_click_escolha}

    Click Web Element Is Visible            ${btn_guardar_endereco}

    Pause Execution                         Clique em ok se o quadrado CS-${numero_calcada} foi criado

    Sleep                                   1s

#===================================================================================================================================================================
Alterar Endereço
    Click Web Element Is Visible            ${btn_modificar_atributo}
    Click Web Element Is Visible            ${btn_modificar_atributo_local}

    Pause Execution                         Clique em ok se o quadrado CS-${numero_calcada} foi criado

    Click Web Element Is Visible            ${btn_localizacao}
    Click Web Element Is Visible            ${btn_opcoes_adicionais_localizacao}
    Click Web Element Is Visible            ${btn_editar_localizacao}

    Sleep                                   3s
    Input Text Web Element Is Visible       ${input_numero_fachada}                 ${Number_Alteração}

    Click Web Element Is Visible            ${btn_confirmar_endereço}

    ${Quantia_linha}=                       Get Element Count is Visible            ${linhas_endereço}
    
    IF  "${Quantia_linha}" == "1"
        ${value_linha}=                     Get Text Element is Visible             ${linha_validar_endereco}                               
        ${a}=                               Split String                            ${value_linha}                          ,
        ${a[1]}=                            Replace String                          ${a[1]}                                 ${SPACE}                                ${EMPTY}                             
        IF   "${a[1]}" != "${Number_Alteração}"    
            Fatal Error                     \nNumero da fachada está diferente 
        END                    
    END
#===================================================================================================================================================================
Valida Abas Ordem
    [Arguments]                             ${TIPO_ORDEM}
    ...                                     ${VALIDACAO_COMPLETA}=NAO
    ...                                     ${ESTADO_ITEM}=Em provisão
    ...                                     ${MASSA}=1
    ...                                     ${TENTATIVAS_FOR}=5
    [Documentation]                         Valida as abas das Ordems
    ...                                     | =Arguments= | =Description= |
    ...                                     | `TIPO_ORDEM` | Tipo da Ordem a ser validada. Valores esperados: "ACESSO GPON" ou "SERVIÇO VPN". Argumento obrigatório. |
    ...                                     | `VALIDACAO_COMPLETA` | Determina se a validação vai ser completa ou simples. Valores esperados: "SIM" ou "NAO" |
    ...                                     | `ESTADO_ITEM` | Valor que será validado para os Serviços. Valores esperados: "Em provisão" ou "Concluído" |
    ...                                     | `MASSA` | Massa que será utilizada. Valores esperados: "1" ou "2" |
    ...                                     | `TENTATIVAS_FOR` | Quantas tentativas devem ser realizadas. Se não for passado argumento, por padrão, será usado " 5 " |
    
    IF    "${MASSA}" == "1"
        ${valor_IDexterno}                  Ler Variavel na Planilha                idExterno                               Global
        ${codigo_logradouro}=               Ler Variavel na Planilha                codigoLogradouro                        Global
        ${CEP}=                             Ler Variavel na Planilha                Address                                 Global
        ${numero_fachada}=                  Ler Variavel na Planilha                Number                                  Global
        ${ID_endereco}=                     Ler Variavel na Planilha                idEndereco                              Global
        ${UF}=                              Ler Variavel na Planilha                UF                                      Global
        ${bairro}=                          Ler Variavel na Planilha                Bairro                                  Global
        ${codigo_localidade}=               Ler Variavel na Planilha                locationCode                            Global
    ELSE IF    "${MASSA}" == "2"
        ${valor_IDexterno}                  Ler Variavel na Planilha                idExterno_2                             Global
        ${codigo_logradouro}=               Ler Variavel na Planilha                codigoLogradouro_2                      Global
        ${CEP}=                             Ler Variavel na Planilha                Address_2                               Global
        ${numero_fachada}=                  Ler Variavel na Planilha                Number_2                                Global
        ${ID_endereco}=                     Ler Variavel na Planilha                idEndereco_2                            Global
        ${UF}=                              Ler Variavel na Planilha                UF_2                                    Global
        ${bairro}=                          Ler Variavel na Planilha                Bairro_2                                Global
        ${codigo_localidade}=               Ler Variavel na Planilha                locationCode_2                          Global
    ELSE
        Fatal Error                         \nMassa não encontrada (Verifique se o campo MASSA está "1" ou "2")
    END

    ${data}=                                Get Current Date                        result_format=%d-%m-%Y
    
    IF    "${TIPO_ORDEM}" == "ACESSO GPON"
        IF    "${VALIDACAO_COMPLETA}" == "SIM"  
            # ABA CARACTERÍSTICAS
            FOR    ${x}      IN RANGE     ${TENTATIVAS_FOR}
                # VALIDA SE O ID DA EMPRESA ESTÁ PREENCHIDO CORRETAMENTE
                ${ID_empresa_retorno}=      Get Text Element is Visible             ${caracteristicas_ID_empresa} 
                ${status_valida}=           Run Keyword And Return Status           Should Be Equal As Strings          ${ID_empresa_retorno}                   Oi
                        
                # CASO NÃO ESTEJA, RECARREGA A PÁGINA
                IF    ${status_valida} != True
                    Reload
                    IF    ${x} == ${TENTATIVAS_FOR}-1
                        Fatal Error                 \nO campos automáticos não foram preenchidos corretamente
                    END
                ELSE
                    ## INFORMAÇÃO BASE
                    ${segmento_retorno}=                Get Text Element is Visible             ${caracteristicas_segmento}
                    Should Be Equal As Strings          ${segmento_retorno}                     EMPRESARIAL
                    ${UF_retorno}=                      Get Text Element is Visible             ${caracteristicas_UF}
                    Should Be Equal As Strings          ${UF_retorno}                           ${UF}
                    ${bairro_retorno}=                  Get Text Element is Visible             ${caracteristicas_bairro}
                    Should Be Uppercase                 ${bairro_retorno}                       ${bairro}
                    ${cod_localidade_retorno}=          Get Text Element is Visible             ${caracteristicas_cod_localidade}
                    Should Be Equal As Strings          ${cod_localidade_retorno}               ${codigo_localidade}
                    ${cod_logradouro_retorno}=          Get Text Element is Visible             ${caracteristicas_cod_logradouro}
                    Should Be Equal As Strings          ${cod_logradouro_retorno}               ${codigo_logradouro}
                    ${ID_empresa_retorno}=              Get Text Element is Visible             ${caracteristicas_ID_empresa}
                    Should Be Equal As Strings          ${ID_empresa_retorno}                   Oi
                    ${ID_endereco_retorno}=             Get Text Element is Visible             ${caracteristicas_ID_endereco}
                    Should Be Equal As Strings          ${ID_endereco_retorno}                  ${ID_endereco}
                    ${numero_fachada_retorno}=          Get Text Element is Visible             ${caracteristicas_numero}
                    Should Be Equal As Strings          ${numero_fachada_retorno}               ${numero_fachada}
                    ${ID_contrato_retorno}=             Get Text Element is Visible             ${caracteristicas_ID_contrato}
                    Should Be Equal As Strings          ${ID_contrato_retorno}                  ${valor_IDexterno}

                    ## ORDER ITEM
                    ${operacao_retorno}=                Get Text Element is Visible             ${características_operacao}
                    Should Be Equal As Strings          ${operacao_retorno}                     Activar
                    ${estado_item_retorno}=             Get Text Element is Visible             ${características_estado_item}
                    Should Be Equal As Strings          ${estado_item_retorno}                  Suspenso
                    ${atividade_retorno}=               Get Text Element is Visible             ${características_atividade}
                    Should Be Equal As Strings          ${atividade_retorno}                    Atribuição concluida

                    ## ESTADOS
                    ${provisao_retorno}=                Get Text Element is Visible             ${caracteristicas_provisao}
                    Should Be Equal As Strings          ${provisao_retorno}                     ${ESTADO_ITEM}
                    ${operacional_retorno}=             Get Text Element is Visible             ${caracteristicas_operacional}
                    Should Be Equal As Strings          ${operacional_retorno}                  Em Serviço
                    ${dataCriacao_retorno}=             Get Text Element is Visible             ${caracteristicas_dataCriacao}
                    Should Be Equal As Strings          ${dataCriacao_retorno}                  ${data}
                    ${dataActualizacao_retorno}=        Get Text Element is Visible             ${caracteristicas_dataActualizacao}
                    Should Be Equal As Strings          ${dataActualizacao_retorno}             ${data}

                    # ABA CLIENTE
                    Click Web Element Is Visible        ${aba_Cliente}
                    Highlight Elements                  ${tipo_cliente}                         duration=100ms                          width=4px                               color=\#dd00dd                          style=solid

                    # ABA SERVIÇOS DE REDE
                    Click Web Element Is Visible        ${aba_ServicosDeRede}
                    Highlight Elements                  ${tipo_servicosDeRede}                  duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
                    
                    ${qtd_linhas}                   Get Element Count is Visible            ${tabela_estado_provisao}
                    FOR    ${i}    IN RANGE    ${1}    ${qtd_linhas}
                        ${estado_retorno}                   Get Text Element is Visible             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //table[@id='rowPedidoListaRfs']//tr[${i}]//td[@class='ui-widget-content'][3]
                        Should Be Equal As Strings          ${estado_retorno}                       ${ESTADO_ITEM}
                    END

                    ## ELEMENTO HOME NETWORK
                    Click Web Element Is Visible        ${btn_olho_home_network}
                    Sleep                               3s

                    ### ESTADO
                    ${provisao_retorno2}=               Get Text Element is Visible             ${select_provisao}
                    Should Be Equal As Strings          ${provisao_retorno2}                    ${ESTADO_ITEM}
                    ${operacional_retorno2}=            Get Text Element is Visible             ${select_operacional}
                    Should Be Equal As Strings          ${operacional_retorno2}                 Em Serviço
                    ${dataCriacao_retorno2}=            Get Text Element is Visible             ${input_data_criacao}
                    Should Be Equal As Strings          ${dataCriacao_retorno2}                 ${data}
                    ${dataActualizacao_retorno2}=       Get Text Element is Visible             ${input_data_actualizacao}
                    Should Be Equal As Strings          ${dataActualizacao_retorno2}            ${data}

                    ### CONECTIVIDADE
                    Scroll To Element                   ${tabela_conectividade}

                    ${elemento_CPE}=                    Get Text                                ${tabela_elemento_de_rede1}
                    Should Contain                      ${elemento_CPE}                         [CPE] ${valor_IDexterno}
                    ${terminacao_1}=                    Get Text                                ${tabela_terminacao_1}
                    Should Contain                      ${terminacao_1}                         [TTP] PTP1
                    ${terminacao_2}=                    Get Text                                ${tabela_terminacao_2}
                    Should Contain                      ${terminacao_2}                         [TTP] PTP2
                    ${elemento_ONT}=                    Get Text                                ${tabela_elemento_ONT}
                    Should Contain                      ${elemento_ONT}                         [ONT] ${valor_IDexterno}

                    Click Web Element Is Visible        ${aba_GPON}
                    Click Web Element Is Visible        ${aba_ServicosDeRede}

                    ## ELEMENTO PON
                    Click Web Element Is Visible        ${btn_olho_PON}

                    ### ESTADO
                    ${provisao_retorno2}=               Get Text Element is Visible             ${select_provisao}
                    Should Be Equal As Strings          ${provisao_retorno2}                    ${ESTADO_ITEM}

                    ${operacional_retorno2}=            Get Text Element is Visible             ${select_operacional}
                    Should Be Equal As Strings          ${operacional_retorno2}                 Em Serviço

                    ${dataCriacao_retorno2}=            Get Text Element is Visible             ${input_data_criacao}
                    Should Be Equal As Strings          ${dataCriacao_retorno2}                 ${data}

                    ${dataActualizacao_retorno2}=       Get Text Element is Visible             ${input_data_actualizacao}
                    Should Be Equal As Strings          ${dataActualizacao_retorno2}            ${data}
                    
                    ### CONECTIVIDADE
                    Scroll To Element                   ${tabela_conectividade}

                    ${elemento_CPE}=                    Get Text                                ${tabela_elemento_de_rede1}
                    Should Contain                      ${elemento_CPE}                         [OLT] ${UF}
                    ${terminacao_1}=                    Get Text                                ${tabela_terminacao_1}
                    Should Contain                      ${terminacao_1}                         [TTP]
                    ${terminacao_2}=                    Get Text                                ${tabela_terminacao_2}
                    Should Contain                      ${terminacao_2}                         [TTP]
                    ${elemento_ONT}=                    Get Text                                ${tabela_elemento_ONT}
                    Should Contain                      ${elemento_ONT}                         [ONT] ${valor_IDexterno}

                    Click Web Element Is Visible        ${aba_GPON}
                    BREAK
                END
            END
        ELSE
            # ABA CARACTERÍSTICAS
            ## ESTADOS
            ${provisao_retorno}=                Get Text Element is Visible             ${caracteristicas_provisao}
            Should Be Equal As Strings          ${provisao_retorno}                     ${ESTADO_ITEM}
            ${operacional_retorno}=             Get Text Element is Visible             ${caracteristicas_operacional}
            Should Be Equal As Strings          ${operacional_retorno}                  Em Serviço
            ${dataCriacao_retorno}=             Get Text Element is Visible             ${caracteristicas_dataCriacao}
            Should Be Equal As Strings          ${dataCriacao_retorno}                  ${data}
            ${dataActualizacao_retorno}=        Get Text Element is Visible             ${caracteristicas_dataActualizacao}
            Should Be Equal As Strings          ${dataActualizacao_retorno}             ${data}
        
            # ABA CLIENTE
            Click Web Element Is Visible        ${aba_Cliente}
            Highlight Elements                  ${tipo_cliente}                         duration=100ms                          width=4px                               color=\#dd00dd                          style=solid

            # ABA SERVIÇOS DE REDE
            Click Web Element Is Visible        ${aba_ServicosDeRede}
            Highlight Elements                  ${tipo_servicosDeRede}                  duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
            
            ${qtd_linhas}                   Get Element Count is Visible            ${tabela_estado_provisao}
            FOR    ${i}    IN RANGE    ${1}    ${qtd_linhas}
                ${estado_retorno}                   Get Text Element is Visible             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //table[@id='rowPedidoListaRfs']//tr[${i}]//td[@class='ui-widget-content'][3]
                Should Be Equal As Strings          ${estado_retorno}                       ${ESTADO_ITEM}
            END
        END

        # ABA SERVIÇOS DE CLIENTE
        Click Web Element Is Visible            ${aba_ServicosDeCliente}
        Highlight Elements                      ${relacao_servicosDeCliente}            duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
        Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}

        # ABA ATRIBUIÇÂO
        Click Web Element Is Visible            ${aba_atribuicao}
        Scroll To Element                       ${atribuicao_tabela_encaminhamento}
        Highlight Elements                      ${atribuicao_tabela_encaminhamento}     duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
        Take Screenshot                         filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    END
    
    IF    "${TIPO_ORDEM}" == "SERVIÇO VPN"
        
        # ABA CARACTERÍSTICAS
        ## ESTADOS
        ${provisao_retorno}=                Get Text Element is Visible             ${caracteristicas_provisao}
        Should Be Equal As Strings          ${provisao_retorno}                     ${ESTADO_ITEM}
        ${operacional_retorno}=             Get Text Element is Visible             ${caracteristicas_operacional}
        Should Be Equal As Strings          ${operacional_retorno}                  Em Serviço
        ${dataCriacao_retorno}=             Get Text Element is Visible             ${caracteristicas_dataCriacao}
        Should Be Equal As Strings          ${dataCriacao_retorno}                  ${data}
        ${dataActualizacao_retorno}=        Get Text Element is Visible             ${caracteristicas_dataActualizacao}
        Should Be Equal As Strings          ${dataActualizacao_retorno}             ${data}
    
        # ABA CLIENTE
        Click Web Element Is Visible        ${aba_Cliente}
        Highlight Elements                  ${tipo_cliente}                         duration=100ms                          width=4px                               color=\#dd00dd                          style=solid

        # ABA SERVIÇOS DE REDE
        Click Web Element Is Visible        ${aba_ServicosDeRede}
        Highlight Elements                  ${tipo_servicosDeRede}                  duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
        
        ${qtd_linhas}                   Get Element Count is Visible            ${tabela_estado_provisao}
        FOR    ${i}    IN RANGE    ${1}    ${qtd_linhas}
            ${estado_retorno}                   Get Text Element is Visible             frame#ifr >>> iframe#dados >>> iframe#ifArvore >>> //table[@id='rowPedidoListaRfs']//tr[${i}]//td[@class='ui-widget-content'][3]
            Should Be Equal As Strings          ${estado_retorno}                       ${ESTADO_ITEM}
        END

        # ABA SERVIÇOS DE CLIENTE
        Click Web Element Is Visible        ${aba_ServicosDeCliente}
        Highlight Elements                  ${relacao_servicosDeCliente}            duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
        Take Screenshot                     filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}

        # ABA ATRIBUIÇÂO
        Click Web Element Is Visible        ${aba_atribuicao}
        Scroll To Element                   ${atribuicao_tabela_encaminhamento}
        Highlight Elements                  ${atribuicao_tabela_encaminhamento}     duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
        Take Screenshot                     filename={index}                        quality=100                             fileType=jpeg                           timeout=${TIMEOUT}
    END

#===================================================================================================================================================================
Cria Ordem IP Connect
    [Arguments]                             ${MASSA}=1
    [Documentation]                         Cria as Ordens "Acesso GPON" e "Serviço VPN IP"
    ...                                     | `MASSA` | Massa que será utilizada. Valores esperados: "1" ou "2" |

    Logar Netwin

    IF    "${MASSA}" == "1"
        Gerar Nr de Serie
        ${valor_IDexterno}                  Set Variable                            ${nr_serie}
        Escrever Variavel na Planilha       ${valor_IDexterno}                      idExterno                               Global
        ${codigo_logradouro}=               Ler Variavel na Planilha                codigoLogradouro                        Global
        ${CEP}=                             Ler Variavel na Planilha                Address                                 Global
        ${numero_fachada}=                  Ler Variavel na Planilha                Number                                  Global
        ${ID_endereco}=                     Ler Variavel na Planilha                idEndereco                              Global
        ${UF}=                              Ler Variavel na Planilha                UF                                      Global
        ${bairro}=                          Ler Variavel na Planilha                Bairro                                  Global
        ${codigo_localidade}=               Ler Variavel na Planilha                locationCode                            Global
    ELSE IF    "${MASSA}" == "2"
        Gerar Nr de Serie
        ${valor_IDexterno}                  Set Variable                            ${nr_serie}
        Escrever Variavel na Planilha       ${valor_IDexterno}                      idExterno_2                             Global
        ${codigo_logradouro}=               Ler Variavel na Planilha                codigoLogradouro_2                      Global
        ${CEP}=                             Ler Variavel na Planilha                Address_2                               Global
        ${numero_fachada}=                  Ler Variavel na Planilha                Number_2                                Global
        ${ID_endereco}=                     Ler Variavel na Planilha                idEndereco_2                            Global
        ${UF}=                              Ler Variavel na Planilha                UF_2                                    Global
        ${bairro}=                          Ler Variavel na Planilha                Bairro_2                                Global
        ${codigo_localidade}=               Ler Variavel na Planilha                locationCode_2                          Global
    END

    Click Web Element Is Visible            ${resource_provisioning_seta}

    Click Web Element Is Visible            ${botao_criar}

    Input Text Web Element Is Visible       ${ID_externo}                           ${valor_IDexterno}
    Click Web Element Is Visible            ${data_objetivo}
    Click Web Element Is Visible            ${selecionar_data_atual}    
    
    # Cria Ordem Serviço Acesso GPON
    Click Web Element Is Visible            ${adicionar_servico}
    Select Options By                       ${selecionar_servico}                   value                                   CFS.ACESSOGPON
    Select Options By                       ${operacao_adicionarServico}            value                                   ACTIVAR
    Input Text Web Element Is Visible       ${campoNome_adicionarServico}           ${valor_IDexterno}
    Input Text Web Element Is Visible       ${input_UF}                             ${UF}
    Input Text Web Element Is Visible       ${input_codigo_localidade}              ${codigo_localidade}
    Input Text Web Element Is Visible       ${input_codigo_bairro}                  ${CEP}
    Input Text Web Element Is Visible       ${input_codigo_logradouro}              ${codigo_logradouro}
    Input Text Web Element Is Visible       ${input_ID_endereco}                    ${ID_endereco}
    Input Text Web Element Is Visible       ${input_num_fachada}                    ${numero_fachada}
    Click Web Element Is Visible            ${aba_Servico_Suporte}
    Click Web Element Is Visible            ${botao_adicionar_adicionarServico}
    
    # Cria Ordem Serviço VPN
    Click Web Element Is Visible            ${adicionar_servico}
    Select Options By                       ${selecionar_servico}                   value                                   CFS.ACCESS_VPN_IP.GPON
    Select Options By                       ${operacao_adicionarServico}            value                                   ACTIVAR
    Input Text Web Element Is Visible       ${campoNome_adicionarServico}           ${valor_IDexterno}
    Select Options By                       ${select_produto_VPN}                   value                                   CN
    Select Options By                       ${select_QOS}                           value                                   DA
    Select Options By                       ${select_ID_perfil}                     value                                   42  # Valor da opção OI_IP_400M_200M
    Select Options By                       ${select_tipo_enderacamento}            value                                   IPV6
    Click Web Element Is Visible            ${aba_Servico_Suporte}
    Click Web Element Is Visible            ${btn_confirmar_servico}
    Click Web Element Is Visible            ${botao_adicionar_adicionarServico}

    Click Web Element Is Visible            ${botao_confirmar}
    Click Web Element Is Visible            ${botao_ok}
    # Click Web Element Is Visible            ${botao_ok}
    
    # Abre nova janela e valida as informações
    Switch Page                             NEW
    Sleep                                   5s
    Valida Abas Ordem                       TIPO_ORDEM=ACESSO GPON                  VALIDACAO_COMPLETA=SIM                  MASSA=${MASSA}

    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT
    
#===================================================================================================================================================================
Gerar Arquivo ao NA
    [Arguments]                             ${COM_CPE}=NAO
    ...                                     ${MASSA}=1
    [Documentation]                         Finaliza os pedidos com ou sem CPE.
    ...                                     | `COM_CPE` | Determina se ativa ou não o CPE. Valores esperados: "SIM" ou "NAO" |
    ...                                     | `MASSA` | Massa que será utilizada. Valores esperados: "1" ou "2" |

    Logar Netwin 

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${btn_resource_provisioning_pesquisar}

    # Pesquisa o ID externo
    IF    "${MASSA}" == "1"
        ${valor_IDexterno}                  Ler Variavel na Planilha                idExterno                               Global
    ELSE IF    "${MASSA}" == "2"
        ${valor_IDexterno}                  Ler Variavel na Planilha                idExterno_2                             Global
    END
    Input Text Web Element Is Visible       ${servicoCliente}                       ${valor_IDexterno}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   3s
    
    # Valida as informações de Serviço VPN
    Click Web Element Is Visible            ${btn_olho_VPN}
    
    Switch Page                             NEW
    Sleep                                   5s
    
    Valida Abas Ordem                       TIPO_ORDEM=SERVICO VPN                  MASSA=${MASSA}

    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT
    
    # Refaz a pesquisa
    Logar Netwin 

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${btn_resource_provisioning_pesquisar}

    # Pesquisa o ID externo
    Input Text Web Element Is Visible       ${servicoCliente}                       ${valor_IDexterno}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   3s
    
    # Valida as informações do Acesso GPON
    Click Web Element Is Visible            ${btn_olho_GPON}
    
    Switch Page                             NEW
    Sleep                                   5s
    
    Valida Abas Ordem                       TIPO_ORDEM=ACESSO GPON                  MASSA=${MASSA}
    
    # Ativa o CPE
    IF    "${COM_CPE}" == "SIM"
        Click Web Element Is Visible            ${btn_mais_CPE}
        Sleep                                   3s

        Select Options By                       ${select_tipo_CPE}                      text                                    ONT
        Select Options By                       ${select_fabricante_CPE}                value                                   ALCATEL
        Select Options By                       ${select_modelo_CPE}                    value                                   I-011G-P
        Select Options By                       ${select_regime_CPE}                    value                                   VENDA
        Click Web Element Is Visible            ${btn_calendario_CPE}
        Click Web Element Is Visible            ${selecionar_data_atual_CPE}
        Input Text Web Element Is Visible       ${input_Nr_serie_CPE}                   ${valor_IDexterno}

        Click Web Element Is Visible            ${btn_adicionar_CPE}
        Click Web Element Is Visible            ${btn_fecha_CPE}
    END

    Click Web Element Is Visible            ${btn_finaliza_pedido_GPON}
    Click Web Element Is Visible            ${botao_ok_CPE}

    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT

    Logar Netwin

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${btn_resource_provisioning_pesquisar}

    Input Text Web Element Is Visible       ${servicoCliente}                       ${valor_IDexterno}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   3s

    # Valida a conclusão das Ordens
    Highlight Elements                      ${tabela_estado_item}                   duration=100ms                          width=4px                               color=\#dd00dd                          style=solid
    ${conclusao_retorno_GPON}               Get Text Element is Visible             ${tabela_estado_item_GPON}
    Should Be Equal As Strings              ${conclusao_retorno_GPON}               Concluído
    ${conclusao_retorno_VPN}                Get Text Element is Visible             ${tabela_estado_item_VPN}
    Should Be Equal As Strings              ${conclusao_retorno_VPN}                Concluído

    Click Web Element Is Visible            ${btn_olho_GPON}
    
    Switch Page                             NEW
    Sleep                                   5s
    
    # Exporta Excel e valida manualmente
    Click Web Element Is Visible            ${aba_atribuicao}
    # Click Web Element Is Visible            ${btn_exporta_excel}
    Pause Execution                         Valide o arquivo Excel e Clique em OK.

    # Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT

#===================================================================================================================================================================
Validar Conclusão de Ordem
    [Arguments]                             ${TIPO_ORDEM}
    ...                                     ${VALIDACAO_COMPLETA}=NAO
    ...                                     ${ESTADO_ITEM}=Activo
    ...                                     ${MASSA}=1
    [Documentation]                         Keyword encadeador apenas para validar.
    ...                                     | =Arguments= | =Description= |
    ...                                     | `TIPO_ORDEM` | Tipo da Ordem a ser validada. Valores esperados: "ACESSO GPON" ou "SERVIÇO VPN". Argumento obrigatório. |
    ...                                     | `VALIDACAO_COMPLETA` | Determina se a validação vai ser completa ou simples. Valores esperados: "SIM" ou "NAO" |
    ...                                     | `ESTADO_ITEM` | Valor que será validado para os Serviços. Valores esperados: "Em provisão" ou "Concluído" |
    ...                                     | `MASSA` | Massa que será utilizada. Valores esperados: "1" ou "2" |

    Logar Netwin
    Click Web Element Is Visible            ${resource_provisioning_seta}

    IF    "${MASSA}" == "1"
        ${valor_IDexterno}                  Ler Variavel na Planilha                idExterno                               Global
    ELSE IF    "${MASSA}" == "2"
        ${valor_IDexterno}                  Ler Variavel na Planilha                idExterno_2                             Global
    END
    Input Text Web Element Is Visible       ${servicoCliente}                       ${valor_IDexterno}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   3s

    Click Web Element Is Visible            ${btn_olho_GPON}
    
    Switch Page                             NEW
    Sleep                                   5s
    
    Valida Abas Ordem                       TIPO_ORDEM=${TIPO_ORDEM}
    ...                                     VALIDACAO_COMPLETA=${VALIDACAO_COMPLETA}
    ...                                     ESTADO_ITEM=${ESTADO_ITEM}
    ...                                     MASSA=${MASSA}

    Close Page                              CURRENT                                 CURRENT
    Close Browser                           CURRENT

#===================================================================================================================================================================
Realizar a Criacao do Bastidor
    [Documentation]                         Realiza a Criação do Bastidor no Netwin

    Click Web Element Is Visible            ${inside_plant_seta}
    Abrir Arvore ate CDOI
    Right Click Web Element Is Visible      ${EQ_CDOI_5PL}
    Click Web Element Is Visible            ${alterarEquipamento}

    Click Web Element Is Visible            ${aba_estruturaFisica}
    Click Web Element Is Visible            ${criarEstrutura}
    Sleep                                   5s

    # POP-UP: Inserir novo bastidor > Confirmar

    Gerar Numero de Serie
    Input Text Web Element Is Visible       ${identificacao_fisica}                 ${identFisica}
    Select Element is Visible               ${modelo_bastidor}                      BASTIDOR-19-44U_C

    ${codigo}=                              Get Text Element is Visible             ${codigo_bastidor}
    Escrever Variavel na Planilha           ${codigo}                               Codigo                                  Global
    Ler Variavel na Planilha                Codigo                                  Global
    Input Text Web Element Is Visible       ${numero_logico}                        ${codigo}

    Select Element is Visible               ${ciclo_de_vida}                        Instalado
    Select Element is Visible               ${estado_operacional}                   Em Serviço
    Select Element is Visible               ${legado}                               Não
    Input Text Web Element Is Visible       ${observacoes}                          teste

    Click Web Element Is Visible            ${aba_localizacao}
    Input Text Web Element Is Visible       ${filaLado}                             11B
    Input Text Web Element Is Visible       ${posicao}                              10A

    Click Web Element Is Visible            ${aba_estruturaFisica}
    Get Text Element is Visible Valida      ${altura}                               ==                                      2200
    Get Text Element is Visible Valida      ${largura}                              ==                                      600
    
    Click Web Element Is Visible            ${aba_caracteristicas}
    Click Web Element Is Visible            ${confirmarCriacao}
    Click Web Element Is Visible            ${fecharAlerta}
    #Verificar que o bastidor foi criado, aparecerá ao lado direito


#===================================================================================================================================================================
Abrir Arvore ate CDOI
    [Documentation]                         Abre as opções da árvore até chegar no CDOI:\n
    ...                                     BA > Feira de Santana > FSA - Feira de Santana > Estação Predial > GV01 - Feira de Santana > CDOI

    Click Web Element Is Visible            ${inside_plant_seta}
    Click Web Element Is Visible            ${abrir_BA}
    Click Web Element Is Visible            ${abrir_FeiraDeSantanda}
    Click Web Element Is Visible            ${abrir_FSA_FeiraDeSantana}
    Click Web Element Is Visible            ${abrir_estacaoPredial}
    Click Web Element Is Visible            ${abrir_GV01_FeiraDeSantada}
    Click Web Element Is Visible            ${abrir_CDOI}

#===================================================================================================================================================================
Gerar Numero de Serie
    [Documentation]                         Gera uma variavel que é composta por 8 números aleatorios
    ...                                     \nUtilizada como Identificação Física para criação de bastidor.
    ${numeros}=                             Generate Random String                  8                                       1234567890
    ${identFisica}=                         Set Variable                            ${numeros}
    Set Global Variable                     ${identFisica}

#===================================================================================================================================================================
Criar Modulo
    [Documentation]                         Realiza a Criação do Modulo no Netwin

    ${codigo2}=                             Get Text Element is Visible             ${codigo_bastidor2}
    Escrever Variavel na Planilha           ${codigo2}                              Identificacao Fisica                    Global
    Ler Variavel na Planilha                Identificacao Fisica                    Global
    Input Text Web Element Is Visible       ${identificacao_fisica2}                ${codigo2}
    Select Element is Visible               ${legado2}                              Não
    Input Text Web Element Is Visible       ${observacoes2}                         teste

    Click Web Element Is Visible            ${aba_localizacao2}
    Select Element is Visible               ${vista}                                Frente
    Input Text Web Element Is Visible       ${localizacaoX}                         47
    Input Text Web Element Is Visible       ${localizacaoY}                         48

    Click Web Element Is Visible            ${aba_UFs}
    Select Element is Visible               ${UF_operacao}                          Criar nova unidade funcional
    Select Element is Visible               ${UF_tipo}                              CDOI 128 SC-APC
    Input Text Web Element Is Visible       ${UF_codificacao}                       P2
    
    Click Web Element Is Visible            ${confirmarCriacao2}
    Click Web Element Is Visible            ${fecharAlerta2}
    #POP-UP: Clicar em confirmar
    Click Web Element Is Visible            ${xFinalizar}

    Right Click Web Element Is Visible      ${EQ_CDOI_5PL}
    Click Web Element Is Visible            ${alterarEquipamento}

    Click Web Element Is Visible            ${aba_estruturaFisica}
    Click Web Element Is Visible            ${icone_olho}
    #POP-UP: Verificar que o Módulo foi criado e fechar a janela
    
#===================================================================================================================================================================
Criar Placa
    [Documentation]                         Realiza a Criação da Placa no Netwin

    Abrir Arvore ate CDOI
    Click Web Element Is Visible            ${abrir_EQ_CDOI_5PL}
    
    #Clicar em "Criar Placa" manualmente, no novo módulo: Clicar nos sinais de mais de [BAS] > [SB] e Botão direito em [SLOT] 1 > Criar Placa
    Pause Execution                         Abra no equipamento: BAS > SB > Clique com botão direito em SLOT 1 > Criar Placa

    Select Element is Visible               ${placa_modelo}                         BAND CDOI 96/128 SC-APC (GENÉRICO) // GENÉRICO (GENÉRICO)
    Select Element is Visible               ${placa_cicloVida}                      Instalado
    Select Element is Visible               ${placa_estadoOperacional}              Em Serviço
    Select Element is Visible               ${legado}                               Não
    Input Text Web Element Is Visible       ${observacoes}                          teste

    Click Web Element Is Visible            ${aba_localizacao}
    Select Element is Visible               ${unidade_funcional}                    CDOI-5PL | P2
    Click Web Element Is Visible            ${aba_outros}
    Click Web Element Is Visible            ${confirmarCriacao}
    Click Web Element Is Visible            ${fechar_confirmacao2}
    Sleep                                   2s
    Click Web Element Is Visible            ${confirmarCriacao2}
    Click Web Element Is Visible            ${fechar_confirmacao}
    
    Reload
    Click Web Element Is Visible            ${abrir_BA}
    Click Web Element Is Visible            ${abrir_FeiraDeSantanda}
    Click Web Element Is Visible            ${abrir_FSA_FeiraDeSantana}
    Click Web Element Is Visible            ${abrir_estacaoPredial}
    Click Web Element Is Visible            ${abrir_GV01_FeiraDeSantada}
    Click Web Element Is Visible            ${abrir_CDOI}
    Right Click Web Element Is Visible      ${EQ_CDOI_5PL}
    
    Click Web Element Is Visible            ${consultarEquipamento}
    Click Web Element Is Visible            ${aba_estruturaFisica}
    Take Screenshot Web Element is visible                                          ${bastidores}
    Take Screenshot Web Element is visible                                          ${shelves}
    Take Screenshot Web Element is visible                                          ${placas}

#===================================================================================================================================================================
Limpar Placa
    [Documentation]                         Limpar a placa antes da criação de uma nova no Netwin

    Abrir Arvore ate CDOI
    Click Web Element Is Visible            ${abrir_EQ_CDOI_5PL}

    #Clicar em "Criar Placa" manualmente, no novo módulo: Clicar nos sinais de mais de [BAS] > [SB] e Botão direito em [SLOT] 1 > Criar Placa
    Pause Execution                         Abra no equipamento: BAS > SB > SLOT 1 > Clique com botão direito na BAND > Eliminar Placa

    Click Web Element Is Visible            ${confirmarCriacao2}
    Click Web Element Is Visible            ${botao_ok_remover}
    Click Web Element Is Visible            ${fechar_confirmacao}

#===================================================================================================================================================================
Remover Caixa
    [Documentation]                         Realiza a Criação da Placa no Netwin
    Click Web Element Is Visible            ${btn_eliminar}
    Click Web Element Is Visible            ${btn_eliminar_local}
    Sleep                                   3s
    Pause Execution                         Clique na caixa e clique em OK na caixa de dialogo deseja eliminar a caixa ao final clique em OK na aqui
#=================================================================================================================================================================== 