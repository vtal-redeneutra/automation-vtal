*** Settings ***
Documentation                               Scripts configuração remota.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../RESOURCE/API/RES_API.robot
#Resource                                    ../../RESOURCE/COMMON/RES_LOG.robot



*** Keywords ***
#===================================================================================================================================================================
Desabilitando SSID
    [Documentation]                         Realiza desabilitação do SSID através de requisição http utilizando método POST. 
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/serviceActivationAndConfiguration/v1/configuration``|
    [Tags]                                  DesabilitaSSID

    Retornar Token Vtal

    ${type}=                                Set Variable                            HGW_WIFI_CONFIGURATION
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 
    ${frequencyBand}=                       Ler Variavel na Planilha                frequencyBand                           Global
    ${wifiIndex}=                           Ler Variavel na Planilha                wifiIndex                              Global
    ${adminStatus}=                         Ler Variavel na Planilha                adminStatus                             Global

    ${Response}=                            POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${type}","parameters": {"frequencyBand": "${frequencyBand}","wifiIndex": ${wifiIndex},"adminStatus": ${adminStatus}}},"customer": {"subscriberId": "${subscriberId}"}}
    
    ${desabilitacaoID}=                     Get Value From Json                     ${Response}                             $.configuration.id
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Desabilitação realizada.
        Escrever Variavel na Planilha       ${desabilitacaoID[0]}                   desabilitacaoId                         Global
    END
    
#===================================================================================================================================================================
Troca de Senha WiFi 
    [Documentation]                         Realiza troca de senha do WiFi através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/serviceActivationAndConfiguration/v1/configuration``|
    [Tags]                                  TrocaSenhaWiFi

    Retornar Token Vtal

    ${type}=                                Set Variable                            HGW_WIFI_SET_PASSWD
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 
    ${wifiIndex}=                           Ler Variavel na Planilha                wifiIndex                               Global
    ${passwd}=                              Ler Variavel na Planilha                Password                                Global
    ${mode}=                                Ler Variavel na Planilha                configMode                              Global

    ${Response}=                            POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${type}","parameters": {"wifiIndex": "${wifiIndex}","passwd": "${passwd}","mode": "${mode}"}},"customer": {"subscriberId": "${subscriberId}"}}                                      
    
    ${configId}=                            Get Value From Json                     ${Response}                             $.configuration.id
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Troca de senha realizada.
        Escrever Variavel na Planilha       ${configId[0]}                          configurationId                         Global
    END

        
#===================================================================================================================================================================
Troca de criptografia da rede Wifi
    [Documentation]                         Realiza troca de criptografia da rede Wifi através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/serviceActivationAndConfiguration/v1/configuration``|
    [Tags]                                  TrocaCriptografiaRedeWIFI

    Retornar Token Vtal

    
    ${type}=                                Set Variable                            HGW_WIFI_CONFIGURATION
    ${mode}=                                Set Variable                            11i
    ${wifiIndex}=                           Ler Variavel na Planilha                wifiIndex                               Global
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global 

    
    ${Response}=                            POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${type}","parameters": {"wifiIndex": "${wifiIndex}","mode": "${mode}"}},"customer": {"subscriberId": "${subscriberId}"}}
    
    ${RedeWIFI_ID}=                         Get Value From Json                     ${Response}                             $.configuration.id
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code 

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Troca realizada.
        Escrever Variavel na Planilha       ${RedeWIFI_ID[0]}                       trocaRedeWifi                           Global
    END

#===========================================================================================================================================================================================
Realizar solicitação reboot ONT/CPE
    [Documentation]                         Realiza reboot da ONT/CPE através de requisição http utilizando método POST.
    ...                                     | ``URL_API`` | ``https://apitrg.vtal.com.br/api/serviceActivationAndConfiguration/v1/configuration``|
    [Tags]                                  SolicitacaoReboot

    Retornar Token Vtal

    ${type}=                                Set Variable                            GPON_ONT_RESET
    ${subscriberId}=                        Ler Variavel na Planilha                subscriberId                            Global

    ${Response}=                            POST_API                                ${API_BASECONFIGURATION}/configuration                                          "configuration": {"action": {"type": "${type}"},"customer": {"subscriberId": "${subscriberId}"}}
    
    ${Reboot_Id}=                           Get Value From Json                     ${Response}                             $.configuration.id
    ${returnedCode}=                        Get Value From Json                     ${Response}                             $.control.code

    IF  "${returnedCode[0]}" != "200"
        Log to console     ${Response}
        Fatal Error    Código retornado não é igual a 200.

    ELSE 
        Log to console    \n Solicitação de reboot realizada.
        Escrever Variavel na Planilha       ${Reboot_Id[0]}                         rebootId                                Global
    END

#===========================================================================================================================================================================================