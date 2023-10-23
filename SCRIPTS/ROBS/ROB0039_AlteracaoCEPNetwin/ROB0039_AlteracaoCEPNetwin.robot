*** Settings ***
Documentation                               Scripts de “Transformando” o CEP no Netwin 

Resource                                    ../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ../../RESOURCE/NETWIN/PAGE_OBJECTS.robot 
Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

*** Variables ***
${IDSurvey}

*** Keywords ***
Transformar CEP Netwin 
    [Documentation]                         Keyword encadeador TRG 
     ...                                    \n Função usada para logar no Netwin, fazer a pesquisa pelo IDSurvey e mudar o CEP de viável para parcial ou parcial para viavel.  
     ...                                    Execução feita manualmente e assim finalizado o script. 

    Logar Netwin 
    Localizar IDSurvey

#===================================================================================================================================================================  

