*** Settings ***
Documentation                               Scripts para validar ordem de venda ou modificação no Netwin 

Resource                                    ../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ../../RESOURCE/NETWIN/PAGE_OBJECTS.robot 
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/SOM/UTILS.robot
Resource                                    ../../RESOURCE/SOM/PAGE_OBJECTS.robot
Resource                                    ../../RESOURCE/SOM/VARIABLES.robot

*** Variables ***
${IDSurvey}

*** Keywords ***
Validar Ordem Venda ou Modificacao
    [Documentation]                         Keyword encadeador TRG 
     ...                                    \n Função usada para logar no SOM e pegar o valor do Acesso GPON, e após isso, logar no Netwin, e acessar o Resource Provisioning para fazer as validações. 

    ${VALOR_PESQUISA}=                      Ler Variavel na Planilha                associatedDocument                      Global

    Login SOM
    
    Click Web Element Is Visible            ${SOM_btn_query}
    Input Text Web Element Is Visible       ${SOM_input_ref}                       ${VALOR_PESQUISA}
    Sleep                                   3s
    Click Web Element Is Visible            ${SOM_btn_search}
    
    Wait For Elements State                 (//input[contains(@name,'move')])[1]    visible                                 timeout=${TIMEOUT}
    Click Web Element Is Visible            ${SOM_rb_Preview}
    Sleep                                   3s
    Click Web Element Is Visible            (//input[contains(@name,'move')])[1]

    #Pegar valor do Acesso GPON
    Take Screenshot Web Element is visible  ${SOM_Acesso_GPON}
    ${acessoGPON}=                          Browser.Get Text                        ${SOM_Acesso_GPON}
    Escrever Variavel na Planilha           ${acessoGPON}                           acessoGPON                              Global

    Close Browser                           CURRENT

    #Netwin
    Logar Netwin

    Click Web Element Is Visible            ${resource_provisioning}
    Click Web Element Is Visible            ${resource_provisioning_seta}
    Input Text Web Element Is Visible       ${servicoCliente}                       ${acessoGPON}
    Click Web Element Is Visible            ${pesquisar_pg2}
    Sleep                                   5s

    Take Screenshot Web Element is visible  ${acessoGPON_estado_item}
    ${acessoGPON_estadoItem}=               Browser.Get Text                        ${acessoGPON_estado_item}
    Should Be Equal As Strings              ${acessoGPON_estadoItem}                Concluído

    Close Browser                           CURRENT

#===================================================================================================================================================================  

