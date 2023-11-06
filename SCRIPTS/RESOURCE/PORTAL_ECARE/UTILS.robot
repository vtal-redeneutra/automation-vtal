*** Settings ***
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     Browser

Resource                                    ../../RESOURCE/PORTAL_ECARE/PAGE_OBJECTS.robot
Resource                                    ../../RESOURCE/PORTAL_ECARE/VARIABLES.robot
Resource                                    ../COMMON/RES_UTIL.robot



*** Keywords ***

#===================================================================================================================================================================
Login Portal E-care
    [Documentation]                         Logar no Portal E-care com usuário e senha
    [TAGS]                                  Login Portal E-care

    ${usuarioPortalCare}=                   Ler Variavel na Planilha                emailContato                            Global    
    ${senhaPortalCare}=                     Ler Variavel na Planilha                senhaContato                            Global                     
    
    Contexto para navegador                 ${UrlPortalECare}                                                        
    Wait For Elements State                 ${buttonFazerLoginSSO}                  visible                                 timeout=${TIMEOUT}
    Click Web Element Is Visible            ${buttonFazerLoginSSO}
    
    Input Text Web Element Is Visible       ${usuarioPortal}                        ${usuarioPortalCare}
    Input Text Web Element Is Visible       ${senhaPortal}                          ${senhaPortalCare}
    Click Web Element Is Visible            ${buttonEntrar}
#===================================================================================================================================================================
Valida contato no portal E-care
    [Documentation]                         Processo automatizado faz login no portal e valida algumas informaçoes do contato dentro do portal E-care.
    
    Login Portal E-care

    ${nomeCompletoContato}=                 Ler Variavel na Planilha                nomeCompleto                            Global                     
    ${emailContato}=                        Ler Variavel na Planilha                emailContato                            Global                     
    ${nomeConta}=                           Ler Variavel na Planilha                nomeConta                               Global 
    ${numeroContrato}=                      Ler Variavel na Planilha                numeroContrato                          Global 
    
    Click Web Element Is Visible            ${buttonMeuPerfil}    
    Click Web Element Is Visible            ${PerfilContato}
    Get Text Element is Visible Valida      xpath=//span[@class="uiOutputText"][contains(.,'${nomeCompletoContato}')]       ==                                      ${nomeCompletoContato}
    Get Text Element is Visible Valida      ${validaEmailContato}                   ==                                      ${emailContato}
    
    Click Web Element Is Visible            ${buttonTresPontos}
    Click Web Element Is Visible            ${buttonContratoECare}
    Click Web Element Is Visible            ${setaMeusContratos}
    Click Web Element Is Visible            ${optionTodosContratos}
    Sleep                                   5s
    Click Web Element Is Visible            xpath=//*[text()="Número do contrato"]/../../../../../..//a[@data-aura-class="forceOutputLookup"][contains(.,'${numeroContrato}')]
    Get Text Element is Visible Valida      xpath=//div[@class="test-id__section-content slds-section__content section__content"]//a[contains(.,'${nomeConta}')]    ==                                      ${nomeConta}             
    Close Browser                           CURRENT
#===================================================================================================================================================================                       