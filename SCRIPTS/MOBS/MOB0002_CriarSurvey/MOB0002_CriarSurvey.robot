*** Settings ***
Documentation                               MOB Initial

Resource                                    ../../RESOURCE/CE_MOBILE/UTILS.robot
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Library                                     OperatingSystem


*** Variables ***


${SETA_BAIXO}                               20
${ENTER}                                    66


*** Keywords ***



#===========================================================================================================================
Criar Survey 1UC
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza a criação de survey com somente uma Unidade de Cliente.

    Abrir Aplicativo CE_MOBILE
    Selecionar Mapa

    ${Cep}=                                 Ler Variavel na Planilha                Address                                 Global
    ${Numero}=                              Ler Variavel na Planilha                Number                                  Global
    ${TipoComplemento}=                     Ler Variavel na Planilha                typeComplement1                         Global
    ${Complemento}=                         Ler Variavel na Planilha                value1                                  Global
    ${Logradouro}=                          Ler Variavel na Planilha                Logradouro                              Global


    ${isVisible}=  Run Keyword And Return Status   Element Should Be Visible        ${Button_OK}
    WHILE    ${isVisible}
        Click Element Is Visible            ${Button_OK}
        ${isVisible}=  Run Keyword And Return Status   Wait Until Element Is Visible    ${Button_OK}    2
    END
    
    Click Element Is Visible                ${Criar_Survey_1UC}
    Click Element Is Visible                ${Button_Mapa_1UC}

    @{Clicar_Mapa}	                        Create List                            	500	                                    500      
    Tap With Positions                      2000                                    ${Clicar_Mapa}
    Click Element Is Visible                ${Button_Mapa_Aceitar}
    


    #PRIMEIRA ABA
    Click Element Is Visible                ${Spinner_Zona}
    Click Element Is Visible                ${Spinner_Opcao_01}

    Input Text Element Is Visible           ${Input_Pisos}                          1

    Click Element Is Visible                ${Radio_Residencia}
    Click Element Is Visible                ${Radio_Edificacao_Completa}

    Input Text Element Is Visible           ${Input_Cep}                            ${Cep}

    Input Text Element Is Visible           ${Input_Numero}                         ${Numero}

    Input Text Element Is Visible           ${Input_Logradouro_1UC}                 ${Logradouro}
    Sleep                                   2s
    Press Keycode                           ${SETA_BAIXO}


    Click Element Is Visible                ${Spinner_Tipo_Complemento}
    Sleep                                   2s
    Press Keycode                           ${SETA_BAIXO}
    ${Complemento_Selecionado}=             AppiumLibrary.Get Text                  ${Spinner_Selecionado}
    WHILE    "${Complemento_Selecionado}" != "${TipoComplemento}"
        Press Keycode                       ${SETA_BAIXO}
        ${Complemento_Selecionado}=         AppiumLibrary.Get Text                  ${Spinner_Selecionado}
        IF    "${Complemento_Selecionado}" == "${TipoComplemento}"
            Click Element Is Visible        ${Spinner_Selecionado}
            BREAK
        END
    END

    Input Text Element Is Visible           ${Input_Complemento}                    ${Complemento}
    Click Element Is Visible                ${Spinner_Nome_Imovel}
    Click Element Is Visible                ${Spinner_Nome_Imovel_Valor}
    Input Text Element Is Visible           ${Input_Nome_Imovel}                    1



    #SEGUNDA ABA    
    Click Element Is Visible                ${Segunda_Aba_1UC}
    Click Element Is Visible                ${Spinner_Nome_Survey}
    Click Element Is Visible                ${Spinner_Nome_Survey_Valor}
    Click Element Is Visible                ${Spinner_Survey_Tecnico}
    Click Element Is Visible                ${Spinner_Survey_Tecnico_Valor}
    Click Element Is Visible                ${Button_Finalizar}
    Click Element Is Visible                ${Button_Finalizar_Ok}
    Sleep                                   2s
    Swipe                                   800    800    800    200
    Click Element Is Visible                ${Button_Pagina_Inicial}
    Click Element Is Visible                ${Button_Pagina_Inicial_Sim}
    

    
#===========================================================================================================================
Criar Survey Mult_UC
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza a criação de survey com mais de uma Unidade de Cliente.


    ${isVisible}=  Run Keyword And Return Status   Wait Until Element Is Visible    ${Button_OK}    5
    WHILE    ${isVisible}
        Click Element Is Visible            ${Button_OK}
        ${isVisible}=  Run Keyword And Return Status   Wait Until Element Is Visible    ${Button_OK}    2
        Log    ${isVisible}
    END

    #Importação da foto para upload no app
    Run                                     adb push C:/IBM_VTAL/SCRIPTS/TRG/TRG_NETWIN_140_CriarManterSurveys/input/imagem.jpg sdcard/DCIM/SharedFolder/

    Click Element Is Visible                ${Criar_Survey_Multi_UC}
    Click Element Is Visible                ${Button_Mapa_Multi_UC}

    @{Clicar_Mapa}	                        Create List                            	450	                                    500      
    Tap With Positions                      2000                                    ${Clicar_Mapa}
    Click Element Is Visible                ${Button_Mapa_Aceitar}
    

    Preencher Identificação da Edificação
    Preencher Caixa de Entrada Interna
    Preencher Prumada
    Preencher Caixa de Piso
    Preencher Outras Informações


#===========================================================================================================================
Selecionar Mapa
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza o upload do arquivo de mapa no aplicativo.
    Click Element Is Visible                ${Button_Opcoes}
    Click Element Is Visible                ${Text_Escolher_Mapa}
    Click Element Is Visible                ${Button_OK}
    Click Element Is Visible                ${Pasta_CE_Mobile}
    Click Element Is Visible                ${Pasta_CE_Mobile_Maps}
    Click Element Is Visible                ${Arquivo_Mapa}
    Click Element Is Visible                ${Button_Confirmar_Mapa}


#===========================================================================================================================
Preencher Identificação da Edificação
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza o preenchimento das informações da aba "Identificação da Edificação"
    ...                                     durante a criação de survey com mais de uma Unidade de Cliente
    
    ${Cep}=                                 Ler Variavel na Planilha                Address                                 Global
    ${Numero}=                              Ler Variavel na Planilha                Number                                  Global
    ${TipoComplemento}=                     Ler Variavel na Planilha                typeComplement1                         Global
    ${Complemento}=                         Ler Variavel na Planilha                value1                                  Global
    ${Logradouro}=                          Ler Variavel na Planilha                Logradouro                              Global

    Click Element Is Visible                ${Spinner_Zona_Multi_UC}
    Click Element Is Visible                ${Spinner_Opcao_01}
    Click Element Is Visible                ${Radio_Completo}
    Click Element Is Visible                ${Radio_Edificacao_Completa}

    Input Text Element Is Visible           ${Input_Cep}                            ${Cep}

    Input Text Element Is Visible           ${Input_Numero}                         ${Numero}
    
    Input Text Element Is Visible           ${Input_Logradouro_1UC}                 ${Logradouro}
    Sleep                                   2s
    Press Keycode                           ${SETA_BAIXO}


    Click Element Is Visible                ${Spinner_Tipo_Complemento}
    Sleep                                   2s
    Press Keycode                           ${SETA_BAIXO}
    ${Complemento_Selecionado}=             AppiumLibrary.Get Text                  ${Spinner_Selecionado}
    WHILE    "${Complemento_Selecionado}" != "${TipoComplemento}"
        Press Keycode                       ${SETA_BAIXO}
        ${Complemento_Selecionado}=         AppiumLibrary.Get Text                  ${Spinner_Selecionado}
        IF    "${Complemento_Selecionado}" == "${TipoComplemento}"
            Click Element Is Visible        ${Spinner_Selecionado}
            BREAK
        END
    END

    Input Text Element Is Visible           ${Input_Complemento}                    ${Complemento}
    Click Element Is Visible                ${Spinner_Nome_Imovel}
    Click Element Is Visible                ${Spinner_Nome_Imovel_Valor}
    Input Text Element Is Visible           ${Input_Nome_Imovel}                    1


#===========================================================================================================================
Preencher Caixa de Entrada Interna
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza o preenchimento das informações da aba "Caixa de Entrada Interna"
    ...                                     durante a criação de survey com mais de uma Unidade de Cliente
    
    Click Element Is Visible                ${Tab_Caixa_Entrada}
    Input Text Element Is Visible           ${Input_Pisos_Multi_UC}                 1

    Click Element Is Visible                ${Spinner_Divisão_Interna}
    Sleep                                   2s
    Press Keycode                           ${SETA_BAIXO}

    ${Valor_Selecionado}=                   AppiumLibrary.Get Text                  ${Spinner_Selecionado}
    WHILE    "${Valor_Selecionado}" != "Frente"
        Press Keycode                       ${SETA_BAIXO}
        ${Valor_Selecionado}=               AppiumLibrary.Get Text                  ${Spinner_Selecionado}
        IF    "${Valor_Selecionado}" == "Frente"
            Click Element Is Visible        ${Spinner_Selecionado}
            BREAK
        END
    END
    
    Input Text Element Is Visible           ${Input_Divisão_Interna}                1359
    Click Element Is Visible                ${Spinner_Localizacao}
    Click Element Is Visible                ${Spinner_Localizacao_Valor}
    Click Element Is Visible                ${Spinner_Tipo_Acesso}
    Click Element Is Visible                ${Spinner_Tipo_Acesso_Valor}
    Click Element Is Visible                ${Spinner_Espaco_FO}
    Click Element Is Visible                ${Spinner_Espaco_FO_Valor}
    Input Text Element Is Visible           ${Input_Comprimento}                    8
    Click Element Is Visible                ${Button_Comprimento_Add}
    Click Element Is Visible                ${Spinner_Modelo_CDOI}
    Click Element Is Visible                ${Spinner_Modelo_CDOI_Valor}
    Click Element Is Visible                ${Button_Modelo_CDOI_Add}

    Swipe                                   800    800    800    200
    Input Text Element Is Visible           ${Input_Altura}                         346

    Input Text Element Is Visible           ${Input_Largura}                        255

    Input Text Element Is Visible           ${Input_Profundidade}                   115

    Click Element Is Visible                ${Button_Caixa_Entrada_Adicionar}
    Click Element Is Visible                ${Spinner_Caixa_Entrada}
    Click Element Is Visible                ${Spinner_Caixa_Entrada_Valor}




#===========================================================================================================================
Preencher Prumada
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza o preenchimento das informações da aba "Prumada"
    ...                                     durante a criação de survey com mais de uma Unidade de Cliente
    
    Click Element Is Visible                ${Tab_Prumada}
    Click Element Is Visible                ${Spinner_CEI}
    Click Element Is Visible                ${Spinner_CEI_Valor}

    Click Element Is Visible                ${Spinner_Prumada_Divisão_Interna}
    Sleep                                   2s
    Press Keycode                           ${SETA_BAIXO}

    ${Valor_Selecionado}=                   AppiumLibrary.Get Text                  ${Spinner_Selecionado}
    WHILE    "${Valor_Selecionado}" != "Frente"
        Press Keycode                       ${SETA_BAIXO}
        ${Valor_Selecionado}=               AppiumLibrary.Get Text                  ${Spinner_Selecionado}
        IF    "${Valor_Selecionado}" == "Frente"
            Click Element Is Visible        ${Spinner_Selecionado}
            BREAK
        END
    END


    Input Text Element Is Visible           ${Input_Prumada_Divisão_Interna}        1359
    Input Text Element Is Visible           ${Input_Deslocamento_Horizontal}        8
    Click Element Is Visible                ${Radio_Atendimento}
    Click Element Is Visible                ${Spinner_Prumada_Espaco_FO}
    Click Element Is Visible                ${Spinner_Prumada_Espaco_FO_Valor}

    Input Text Element Is Visible           ${Input_Piso_Logico_Inicio}             0
    Input Text Element Is Visible           ${Input_Piso_Logico_Final}              9
    Input Text Element Is Visible           ${Input_Piso_Real_Inicio}               1
    Input Text Element Is Visible           ${Input_Piso_Real_Final}                10

    Click Element Is Visible                ${Radio_Andar}
    Click Element Is Visible                ${Radio_Destinacao}
    Click Element Is Visible                ${Radio_Tipo_Complemento}
    Click Element Is Visible                ${Spinner_Prumada_Complemento}
    Click Element Is Visible                ${Spinner_Prumada_Complemento_Valor}
    Input Text Element Is Visible           ${Input_Prumada_Complemento}            101
    Click Element Is Visible                ${Button_Complemento_Add}
    Click Element Is Visible                ${Spinner_Confirmacao_Complemento}
    Click Element Is Visible                ${Spinner_Confirmacao_Complemento_Valor}
    Swipe                                   800    800    800    100
    Click Element Is Visible                ${Button_Criar}
    Swipe                                   800    800    800    100
    Click Element Is Visible                ${Button_Adicionar}
    Click Element Is Visible                ${Spinner_Prumada}
    Click Element Is Visible                ${Spinner_Prumada_Valor}
    Swipe                                   800    800    800    100
    Click Element Is Visible                ${Button_Salvar}

    


#===========================================================================================================================
Preencher Caixa de Piso
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza o preenchimento das informações da aba "Caixa de Piso"
    ...                                     durante a criação de survey com mais de uma Unidade de Cliente
    
    Click Element Is Visible                ${Tab_Caixa_Piso}
    Click Element Is Visible                ${Spinner_Caixa_Piso_Prumada}
    Click Element Is Visible                ${Spinner_Caixa_Piso_Prumada_Valor}
    Input Text Element Is Visible           ${Input_Caixa_Piso}                     1
    Click Element Is Visible                ${Spinner_Modelo_CDOIA}
    Click Element Is Visible                ${Spinner_Modelo_CDOIA_Valor}
    Click Element Is Visible                ${Button_Modelo_CDOIA_Add}
    Input Text Element Is Visible           ${Input_Caixa_Piso_Altura}              200
    Input Text Element Is Visible           ${Input_Caixa_Piso_Largura}             126
    Input Text Element Is Visible           ${Input_Caixa_Piso_Profundidade}        50
    Click Element Is Visible                ${Button_Caixa_Piso_Add}
    Click Element Is Visible                ${Spinner_Caixa_Piso}
    Click Element Is Visible                ${Spinner_Caixa_Piso_Valor}
    Click Element Is Visible                ${Button_Caixa_Piso_Salvar}



#===========================================================================================================================
Preencher Outras Informações
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza o preenchimento das informações da aba "Outras Informações"
    ...                                     durante a criação de survey com mais de uma Unidade de Cliente
    
    Click Element Is Visible                ${Tab_Outras_Infos}
    Input Text Element Is Visible           ${Input_Nome}                           Eduardo Berg
    Input Text Element Is Visible           ${Input_Telefone}                       19999999999
    Input Text Element Is Visible           ${Input_Email}                          duh.berg@ibm.com

    #FOTO INTERIOR
    Click Element Is Visible                ${Button_Foto_Interior}
    Click Element Is Visible                ${Button_Foto__OK}
    Click Element Is Visible                ${Pasta_DCIM}
    Click Element Is Visible                ${Pasta_SharedFolder}
    Click Element Is Visible                ${Text_Foto_Nome}
    Click Element Is Visible                ${Text_Foto_Nome_OK}

    #FOTO EXTERIOR
    Click Element Is Visible                ${Button_Foto_Exterior}
    Click Element Is Visible                ${Text_Foto_Nome}
    Click Element Is Visible                ${Text_Foto_Nome_OK}

    #FOTO FACHADA
    Click Element Is Visible                ${Button_Foto_Fachada}
    Click Element Is Visible                ${Text_Foto_Nome}
    Click Element Is Visible                ${Text_Foto_Nome_OK}
    
    Click Element Is Visible                ${Spinner_Survey_Nome}
    Click Element Is Visible                ${Spinner_Survey_Nome_Valor}
    Click Element Is Visible                ${Spinner_Tecnico_Multi_UC}
    Click Element Is Visible                ${Spinner_Tecnico_Multi_UC_Valor}
    Swipe                                   800    800    800    100
    Click Element Is Visible                ${Button_Outras_Info_Finalizar}
    Click Element Is Visible                ${Button_Outras_Info_Finalizar_OK}

    Sleep                                   2s
    Swipe                                   800    800    800    200
    Click Element Is Visible                ${Button_Pagina_Inicial_Multi_UC}
    Click Element Is Visible                ${Button_Pagina_Inicial_Sim}
    Sleep                                   2s



#===========================================================================================================================
Exportar Arquivo Survey
    [Documentation]                         \nKeyword utilizada para app CE-Mobile. Realiza a exportação do arquivo .zip com as surveys criadas.
    
    #LIMPAR PASTA DE EXPORTACAO DO CE_MOBILE E DO TRG
    Create Directory                        C:/IBM_VTAL/SCRIPTS/TRG/NETWIN/140_CriarManterSurveys/output
    Sleep                                   5s
    Empty Directory                         C:/IBM_VTAL/SCRIPTS/TRG/NETWIN/140_CriarManterSurveys/output

    Click Element Is Visible                ${Button_Exportar_Levantamento}
    Click Element Is Visible                ${Button_Exportar_Confirmar}

    Run                                     adb pull sdcard/CE-Mobile/output/
    Run                                     adb shell rm -r /sdcard/CE-Mobile/output/*


#===========================================================================================================================