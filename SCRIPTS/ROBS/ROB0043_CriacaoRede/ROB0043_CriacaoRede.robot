*** Settings ***

Resource                                    ../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ../../RESOURCE/NETWIN/PAGE_OBJECTS.robot 
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Library                                     OperatingSystem


*** Keywords ***

Criacao OPT

    Logar Netwin 
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
    
    #Clica no botão + da pagina do mapa
    Click Web Element Is Visible            ${btn_mais_mapa}
    Click Web Element Is Visible            ${btn_mapa_Redefixa}
    Click Web Element Is Visible            ${btn_mapa_equipamento}
    Click Web Element Is Visible            ${btn_mapa_Survey}
    Click Web Element Is Visible            ${btn_mapa_celulas}
    Sleep                                   2s
    Click Web Element Is Visible            ${MenuAdicionar}
    Click Web Element Is Visible            ${OptionLocal}
    Click Web Element Is Visible            ${MenuEdificio}
    Click Web Element Is Visible            ${ButtonEstacaoPredial}
    Pause Execution                         Dê um duplo clique no mapa e aguarda a nova página ser carregada!

    Input Text Web Element Is Visible       ${InputNomeEntidade}                    FTLZ
    Input Text Web Element Is Visible       ${InputDesignacao}                      Ponto de Instalação
    Click Web Element Is Visible            ${InputProjetoCombo}
    Input Text Web Element Is Visible       ${InputProjetoComboPesquisa}            A1-12641-2018-FTTH-ALD-CE_CEOS48
    Click Web Element Is Visible            ${InputProjetoComboValor}
    Input Text Web Element Is Visible       ${InputSigla}                           FTLZ

    Click Web Element Is Visible            ${SelectRedeSuportada}
    Click Web Element Is Visible            ${SelectRedeSuportadaValor}

    Click Web Element Is Visible            ${InputDescricaoCombo}
    Input Text Web Element Is Visible       ${InputDescricaoComboPesquisa}          Edifício (Escritórios)
    Click Web Element Is Visible            ${InputDescricaoComboValor}

    
    #Aba Localização
    Click Web Element Is Visible            ${AbaLocalização}
    Click Web Element Is Visible            ${ButtonAdicionar}

    Click Web Element Is Visible            ${InputFiltroLogradouro}
    ${Cep}=                                 Ler Variavel na Planilha                Address                                 Global
    Input Text Web Element Is Visible       ${InputFiltroLogradouroPesquisa}        ${Cep}
    Click Web Element Is Visible            ${InputFiltroLogradouroValor}
    Sleep                                   5s

    ${Numero}=                              Ler Variavel na Planilha                Number                                 Global
    Input Text Web Element Is Visible       ${InputNumeroFachada}                   ${Numero}
    Click Web Element Is Visible            ${ButtonOK}
    

    #Aba Serviços
    Click Web Element Is Visible            ${AbaServicos}
    FOR    ${i}    IN RANGE    6
        Click Web Element Is Visible        ${InputServicosDisponiveis}
        ${n}=                               Evaluate                                ${i}+1
        Click Web Element Is Visible        iframe#iframe-content-wrapper >>> iframe#externalLocationIframe >>> //ul[@id="select2-location_select_availableServices-results"]//li[${n}]
    END

    #Aba Histórico
    Click Web Element Is Visible            ${AbaHistórico}
    Click Web Element Is Visible            ${InputOrigem}
    Input Text Web Element Is Visible       ${InputOrigemPesquisa}                  Netwin
    Click Web Element Is Visible            ${InputOrigemValor}
    Click Web Element Is Visible            ${ButtonSalvar}
    Sleep                                   5s
        
    Close Browser                           CURRENT