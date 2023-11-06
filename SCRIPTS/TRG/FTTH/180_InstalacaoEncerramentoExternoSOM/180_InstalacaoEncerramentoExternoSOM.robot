*** Settings ***

Suite Setup                                 Setup cenario                           Whitelabel

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ${DIR_FW}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0006_ValidarOrdemSOM/ROB0006_ValidarOrdemSOM.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0012_ConsultarAgendamento/ROB0012_ConsultarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0021_ValidarConfirmacaoAgendamento/ROB0021_ValidarConfirmacaoAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0022_ValidarNotificacaoFW/ROB0022_ValidarNotificacaoFW.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0031_ValidarComplementoFSL/ROB0031_ValidarComplementoFSL.robot

*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/180_InstalacaoEncerramentoExternoSOM.xlsx


*** Test Cases ***

180.01 - Gerar Token de Acesso
    [TAGS]              COMPLETO
    Retornar Token Vtal

180.02/03 - Realizar Consulta de Logradouro
    [TAGS]              COMPLETO
    Consulta Id Logradouro

180.04 - Realizar Consulta de Viabilidade
    [TAGS]              COMPLETO
    Retorna Viabilidade dos Produtos

180.05 - Realizar Consulta de Slots
    [TAGS]              COMPLETO
    Consulta Slot Agendamento

180.06 - Realizar o Agendamento
    [TAGS]              COMPLETO
    Realizar Agendamento

180.07 - Validar a Notificação do Agendamento
    [TAGS]              COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

180.08 - Validar agendamento no FSL
    [TAGS]              COMPLETO
    Validar SA Simples                      valorConta= 
    ...                                     valorOrigem= 
    ...                                     valorProntoExecucao=unchecked
    ...                                     validarEstado=False

180.09 - Realizar a Criação de Ordem (OS)
    [TAGS]              COMPLETO
    Criar Ordem Agendamento                 VELOCIDADE=400

180.10 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]              COMPLETO
    Validar Criação da Ordem                associatedDocument                     >200<

180.11 - Validar a Criação da OS de Instalação via SOM
    [TAGS]              COMPLETO
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                     

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30

XX.XX - Reagendamento Via Api
    [TAGS]              COMPLETO
    Reagendar Pedido OPM e FSL

XX.XX - Atribuir técnico no Field Service
    [TAGS]              COMPLETO
    Troca de Tecnico no Field Service
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Close Browser                           CURRENT
    
180.12 - Validação FSL
    [TAGS]              COMPLETO
    Validar SA Simples                      valorConta=TRGIBM
    ...                                     valorOrigem=TRGIBM
    ...                                     valorProntoExecucao=checked

180.13 - Validar no Field Service
    [TAGS]              COMPLETO
    Valida SA no Field Service

180.14 - Tramitar no SOM o reparo até o encerramento
    [TAGS]              COMPLETO
    Encerrar SA com Sucesso via SOM         codigoEquipamento=617617                nomeTecAuxiliar=Artur Santana

180.15 - Validar encerramento do reparo no SOM
    [TAGS]              COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Fibra Instalação

180.16 - Validar encerramento do reparo no FW
    [TAGS]              COMPLETO
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="START - Inicialização do serviço"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso<

########################################################################################################################################################################################
# SCRIPT A
########################################################################################################################################################################################
180.01 - Gerar Token de Acesso
    [TAGS]              SCRIPT_A
    Retornar Token Vtal

180.02/03 - Realizar Consulta de Logradouro
    [TAGS]              SCRIPT_A
    Consulta Id Logradouro

180.04 - Realizar Consulta de Viabilidade
    [TAGS]              SCRIPT_A
    Retorna Viabilidade dos Produtos

180.05 - Realizar Consulta de Slots
    [TAGS]              SCRIPT_A
    Consulta Slot Agendamento

180.06 - Realizar o Agendamento
    [TAGS]              SCRIPT_A
    Realizar Agendamento

180.07 - Validar a Notificação do Agendamento
    [TAGS]              SCRIPT_A
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='Appointment.PostAppointment'])[1]
    ...                                     RETORNO_ESPERADO=>201<

180.08 - Validar agendamento no FSL
    [TAGS]              SCRIPT_A
    Validar SA Simples                      valorConta= 
    ...                                     valorOrigem= 
    ...                                     valorProntoExecucao=unchecked
    ...                                     validarEstado=False

180.09 - Realizar a Criação de Ordem (OS)
    [TAGS]              SCRIPT_A
    Criar Ordem Agendamento                 VELOCIDADE=400
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

180.10 - Validar a Notificação da Criação da Ordem (OS) via FW Console
    [TAGS]              SCRIPT_A
    Validar Criação da Ordem                associatedDocument                     >200<

180.11 - Validar a Criação da OS de Instalação via SOM
    [TAGS]              SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Numero_Pedido}                    

    @{RETORNO}=                             Create List                             associatedDocument                     

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=30

####################################################################################################################################################################
# SCRIPT B
####################################################################################################################################################################
180.12 - Validação FSL
    [TAGS]              SCRIPT_B
    Validar SA Simples                      valorConta=TRGIBM
    ...                                     valorOrigem=TRGIBM
    ...                                     valorProntoExecucao=checked

180.13 - Validar no Field Service
    [TAGS]              SCRIPT_B
    Valida SA no Field Service

180.14 - Tramitar no SOM o reparo até o encerramento
    [TAGS]              SCRIPT_B
    Encerrar SA com Sucesso via SOM         codigoEquipamento=617617                nomeTecAuxiliar=Artur Santana

180.15 - Validar encerramento do reparo no SOM
    [TAGS]              SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_STATE=Completed
    ...                                     ORDER_TYPE=Vtal Fibra Instalação

180.16 - Validar encerramento do reparo no FW
    [TAGS]              SCRIPT_B
    Validar Evento FW                       VALOR_BUSCA=associatedDocument    
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderStateChangeEvent'])[1]
    ...                                     XPATH_XML=//*[text()="START - Inicialização do serviço"]/../..//textarea
    ...                                     RETORNO_ESPERADO=>Ordem Encerrada com Sucesso<