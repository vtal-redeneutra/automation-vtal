*** Settings ***
Documentation  arquivo de keywords genéricas criadas para utilização e importações necessárias
Library                                     String
Library                                     DateTime
Library                                     Collections
Library                                     AppiumLibrary
Library                                     Dialogs

Resource                                    PAGE_OBJECTS.robot
Resource                                    VARIABLES.robot
Resource                                    ../COMMON/RES_EXCEL.robot
Resource                                    ../COMMON/RES_UTIL.robot


*** Variables ***

${SETA_BAIXO}                               20
${ENTER}                                    66







*** Keywords ***

#====================================================================================================================================
Abrir Aplicativo CE_MOBILE
    [Documentation]                         Keyword responsável por realizar a abertura do aplicativo do CE_MOBILE no emulador BlueStacks

    ${PATH_CE_MOBILE}=                      Set Variable                            ${PATH_RESULTS}/CE_MOBILE
    Create Directory                        ${PATH_CE_MOBILE}

    ${Porta_Appium}=                        Pegar porta Appium

    AppiumLibrary.Open Application          ${REMOTE_URL}     
    ...                                     platformName=Android
    ...                                     appium:deviceName=127.0.0.1:${Porta_Appium} 
    ...                                     appium:udid=127.0.0.1:${Porta_Appium} 
    ...                                     appium:appPackage=pt.ptinovacao.nwosp.cemobilea
    ...                                     appium:appActivity=pt.ptinovacao.nwosp.cemobilea.CEMobileASplashScreen
    ...                                     autoGrantPermissions=true














Click Element Is Visible
    [Documentation]                         Keyword responsável por aguardar o elemento estar vísivel, e então realizar o click no mesmo
    ...                                     \nUtilizada para CE_MOBILE
    [Arguments]                             ${ELEMENT}
    AppiumLibrary.Wait Until Element Is Visible                                     ${ELEMENT}                              ${TIMEOUT}
    Take Screenshot App                     ${ELEMENT}
    AppiumLibrary.Click Element             ${ELEMENT}


Input Text Element Is Visible
    [Documentation]                         Keyword responsável por aguardar o elemento estar vísivel, e então realizar a escrita do valor no mesmo
    ...                                     \nUtilizada para CE_MOBILE
    [Arguments]                             ${ELEMENT}                              ${VALUE}
    Click Element Is Visible                ${ELEMENT}
    AppiumLibrary.Wait Until Element Is Visible                                     ${ELEMENT}                              ${TIMEOUT}
    AppiumLibrary.Input Text                ${ELEMENT}                              ${VALUE}
    Take Screenshot App                     ${ELEMENT}
    Press Keycode                           ${ENTER}


Take Screenshot App
    [Documentation]                         Keyword responsável por aguardar o elemento estar vísivel, e então tirar um print do mesmo
    ...                                     \nUtilizada para CE_MOBILE
    [Arguments]  ${ELEMENT}
    AppiumLibrary.Wait Until Element Is Visible                                     ${ELEMENT}                              ${TIMEOUT}
    # BuiltIn.Sleep  1
    AppiumLibrary.Capture Page Screenshot    filename=print.png

    Validar o Nome da Keyword
    Inserir Print CE_MOBILE no DOC


    

#====================================================================================================================================
#END UTILIDADES
#====================================================================================================================================




