*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario

Suite Setup                                 Setup cenario                           Whitelabel


Resource                                    ../../../RESOURCE/CE_MOBILE/UTILS.robot
Resource                                    ../../../RESOURCE/NETWIN/UTILS.robot
Resource                                    ${DIR_MOBS}/MOB0002_CriarSurvey/MOB0002_CriarSurvey.robot
Resource                                    ${DIR_ROBS}/ROB0042_ImportarArquivoSurveyNetwin/ROB0042_ImportarArquivoSurveyNetwin.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/140_CriarManterSurveys.xlsx


*** Test Cases ***

140.01 - Criar Survey com 1 UC
    Criar Survey 1UC
    
140.02 - Criar Survey com mais de uma UC
    Criar Survey Mult_UC

140.03 - Exportar Arquivo Survey
    Exportar Arquivo Survey
    
140.04 - Importar Arquivo Survey - Netwin
    Importar Arquivo Survey