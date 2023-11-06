*** Settings ***
Documentation                               Scripts de “Transformando” o CEP no Netwin 

Resource                                    ../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ../../RESOURCE/NETWIN/PAGE_OBJECTS.robot 
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot
Library                                     OperatingSystem


*** Keywords ***
Importar Arquivo Survey
    [Documentation]                         \n Função usada para logar no Netwin, e fazer upload do arquivo .zip para o mapa.  


    Logar Netwin 
    
    Click Web Element Is Visible            ${Outside_Plant}
    Click Web Element Is Visible            ${Outside_Plant_Visao_Geo}
    pause execution                         Clique no OK quando o mapa carregar
    Click Web Element Is Visible            ${Button_Utilitarios}
    Click Web Element Is Visible            ${Button_Utilitarios_Survey}
    Click Web Element Is Visible            ${Button_Utilitarios_Survey_Import}
    
    Wait for Elements State                 ${Button_Upload}                        Visible                                 timeout=60
    
    ${Arquivo_Input}=                       List Files In Directory                 C:/IBM_VTAL/SCRIPTS/TRG/NETWIN/140_CriarManterSurveys/output/    *.zip
    Sleep                                   5s
    Upload File By Selector                 ${Input_File}                           C:/IBM_VTAL/SCRIPTS/TRG/NETWIN/140_CriarManterSurveys/output/${Arquivo_Input[0]}
    Sleep                                   5s
    Click Web Element Is Visible            ${Button_Upload}


    ${present}=  Run Keyword And Return Status    Wait for Elements State    ${Td_Sucesso_Importacao}    Visible    100
    IF    ${present} == False
        Fatal Error    \nMensagem de sucesso de importação não foi exibida!
    END
    
#===================================================================================================================================================================  

