*** Settings ***
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     Browser
Library                                     Dialogs
Library                                     ../../RESOURCE/COMMON/LIB/lib_geral.py

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/PORTAL/PAGE_OBJECTS.robot

*** Keywords ***


Login ao Portal Operacional
    ${user}=                                Ler Variavel Param Global         $.Logins.PORTAL.Usuario              
    ${password}=                            Ler Variavel Param Global         $.Logins.PORTAL.Senha               
    ${urlPortal}=                           Ler Variavel Param Global         $.Urls.PORTAL                 
    
    Contexto para navegador                 ${urlPortal}            firefox         

    Browser.Fill Text                       ${userInput}            ${user}
    Browser.Fill Text                       ${passInput}            ${password}
    Browser.Click                           ${loginButtonPortal}
    Wait For Elements State                 xpath=//div[contains(text(),"Bem vindo ao Portal de Serviços das Tenants!")]         visible
    
Acessar ${pagina} no menu do PORTAL
    [Documentation]                         Utilizar o nome que aparece ao lado dos ícones no menu do Portal.
    ...                                     Ex: Ordens de Serviço

    Browser.Click                           xpath=//span[@class="menu-text"][contains(text(),"${pagina}")]/../../..

Logout Portal Operacional
    
    Browser.Click                           ${dropArrowSair}
    Browser.Click                           ${buttonSair}
    Browser.Close Browser                   CURRENT