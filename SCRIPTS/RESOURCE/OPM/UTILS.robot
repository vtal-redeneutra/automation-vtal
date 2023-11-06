*** Settings ***
Documentation                               Arquivo de keywords genéricas criadas para utilização e importações necessárias
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     AppiumLibrary
Library                                     Dialogs

Resource                                    PAGE_OBJECTS.robot
Resource                                    VARIABLES.robot
Resource                                    ../COMMON/RES_EXCEL.robot


*** Variables ***

${TIMEOUT_OPM}      120

*** Keywords ***
#====================================================================================================================================
#UTILIDADES
#====================================================================================================================================
Abrir Aplicativo OPM
    [Documentation]                         Keyword responsável por realizar a abertura do aplicativo do OPM no emulador BlueStacks
    
    
    ${PATH_OPM}=                            Set Variable                            ${PATH_RESULTS}/OPM
    Create Directory                        ${PATH_OPM}

    ${Porta_Appium}=                        Pegar porta Appium

    
    AppiumLibrary.Open Application          ${REMOTE_URL}     
    ...                                     platformName=Android
    ...                                     appium:deviceName=127.0.0.1:${Porta_Appium} 
    ...                                     appium:udid=127.0.0.1:${Porta_Appium} 
    ...                                     appium:appPackage=com.accenture.opmobile 
    ...                                     appium:appActivity=com.accenture.opmobile.MainActivity
    ...                                     autoGrantPermissions=true


    ${present}=  Run Keyword And Return Status    Wait Until Element Is Visible     ${input_matricula_opm}        30
    Run Keyword If    ${present}    Logar no App OPM



Logar no App OPM
    [Documentation]                         Keyword responsável por realizar o Login no aplicativo OPM
    ...                                     \nLê os campos ``Usuario_OPM`` e ``Senha_OPM`` da planilha.

    ${user_OPM}=                            Ler Variavel Param Global               $.Logins.OPM.Usuario                             
    ${password_OPM}=                        Ler Variavel Param Global               $.Logins.OPM.Senha                               
    Set Test Variable                       ${user_OPM}
    Set Test Variable                       ${password_OPM}

    WHILE    True
        ${passed}=      Preencher Login e Validar Captcha
        IF    ${passed} == False
            BREAK
        END
    END
    

Preencher Login e Validar Captcha
    [Documentation]                         Keyword responsável preencher os campos de login do OPM e aguardar o valor do captcha ser preenchido
    ...                                     \nValor do captcha deve ser inserido na caixinha aberta pelo script, para então ser preenchido no aplicativo.

    Input Text Element Is Visible           ${input_matricula_opm}                  ${user_OPM}
    Input Text Element Is Visible           ${input_senha_opm}                      ${password_OPM}
    ${captcha_value}=	                    Get Value From User	Insira a CAPTCHA:	 
    Input Text Element Is Visible           ${input_captcha_opm}                    ${captcha_value}
    Sleep                                   2
    ${CHECK}=    Run Keyword And Return Status        AppiumLibrary.Wait Until Element Is Visible  ${form_login}            10  
    [RETURN]                                ${CHECK}


Click Element Is Visible
    [Documentation]                         Keyword responsável por aguardar o elemento estar vísivel, e então realizar o click no mesmo
    ...                                     \nUtilizada para OPM
    [Arguments]                             ${ELEMENT}
    BuiltIn.Sleep                           1
    Check Loading
    AppiumLibrary.Wait Until Element Is Visible                                     ${ELEMENT}                              ${TIMEOUT_OPM}
    Take Screenshot App                     ${ELEMENT}
    AppiumLibrary.Click Element             ${ELEMENT}
    # BuiltIn.Sleep                           1

Input Text Element Is Visible
    [Documentation]                         Keyword responsável por aguardar o elemento estar vísivel, e então realizar a escrita do valor no mesmo
    ...                                     \nUtilizada para OPM
    [Arguments]                             ${ELEMENT}                              ${VALUE}
    Check Loading
    Click Element Is Visible                ${ELEMENT}
    AppiumLibrary.Wait Until Element Is Visible                                     ${ELEMENT}                              ${TIMEOUT}
    AppiumLibrary.Input Text                ${ELEMENT}                              ${VALUE}
    Take Screenshot App                     ${ELEMENT}
    Press Keycode                           ${ENTER}


Finalizar Jornada e Sair
    [Arguments]                             ${CONFIRMACAO}=NAO
    Click Element Is Visible                ${btn_menu} 
    Click Element Is Visible                ${btn_menu_encerrar_jornada}     
    Click Element Is Visible                ${select_motivo_jornada}     
    Click Element Is Visible                ${select_motivo_logout}     
    Click Element Is Visible                ${btn_encerrar_jornada}     
    IF    "${CONFIRMACAO}" == "SIM"
        Click Element Is Visible            ${btn_encerrar_sim}
    END
    Terminate Application                   com.accenture.opmobile



Take Screenshot App
    [Documentation]                         Keyword responsável por aguardar o elemento estar vísivel, e então tirar um print do mesmo
    ...                                     \nUtilizada para OPM
    [Arguments]                             ${ELEMENT}
    AppiumLibrary.Wait Until Element Is Visible                                     ${ELEMENT}                              ${TIMEOUT_OPM}
    # BuiltIn.Sleep  0.5
    AppiumLibrary.Capture Page Screenshot    filename=print.png    
    # BuiltIn.Sleep  0.5


Check Loading
    [Documentation]                         Keyword responsável por aguardar até que a mensagem de loading do aplicativo OPM desapareça, para então seguir com o script
    ...                                     \nUtilizada para OPM
    ${isVisible}=  Run Keyword And Return Status   Element Should Be Visible        ${loading}
    WHILE    ${isVisible}
        BuiltIn.Sleep  2
        ${isVisible}=  Run Keyword And Return Status   Element Should Be Visible    ${loading}
    END
    # BuiltIn.Sleep  2


    

#====================================================================================================================================
#END UTILIDADES
#====================================================================================================================================




