*** Settings ***

Suite Setup                                 Setup cenario                           Voip

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ${DIR_SOM}/UTILS.robot
Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_MS}/UTILS.robot

Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0008_AtualizarStatusSA/ROB0008_AtualizarStatusSA.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/167_AtivacaoVoipBLEnderecoMultiplosComplementosFechamentoViaFSL.xlsx


*** Test Cases ***
167.01 - Gerar Token de Acesso  
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

167.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Logradouro CPOi

167.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos

167.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Retornar Slot Agendamento Voip

167.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento                    cod_activityType=4936

167.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
   Criar Ordem de Agendamento Voip          
   
167.08 - Validar a Notificação da Criação da Ordem (OS) no Microserviços      
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Extrair dado do Bloco                   START - Inicialização do serviço        id                                      somOrderId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso

167.09 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument                                                       

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

#===================================================================================================================================================================

167.10/12/14 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_B
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H

167.11/13/15 - Validar Mudança de Status do FSL no Microserviços
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

167.16 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas                    

167.17 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service
   
167.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

167.19 - Validar a Notificação de Encerramento no Microserviços
    [TAGS]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]       Ordem Encerrada com Sucesso para Banda Larga e VOIP OI

#===================================================================================================================================================================

167.01 - Gerar Token de Acesso  
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Token Vtal

167.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Logradouro CPOi

167.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_COMPLETO
    Retorna Viabilidade dos Produtos

167.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Slot Agendamento Voip

167.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_COMPLETO
    Realizar Agendamento                    cod_activityType=4936

167.07 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_COMPLETO
    Criar Ordem de Agendamento Voip         #VELOCIDADE_DOWN=1000                    VELOCIDADE_UP=500
   
167.08 - Validar a Notificação da Criação da Ordem (OS) no Microserviços      
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderCreateEvent referente ao associatedDocument
    Extrair dado do Bloco                   START - Inicialização do serviço        id                                      somOrderId
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     msg:Description                         Sucesso

167.09 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                          

    @{RETORNO}=                             Create List                             associatedDocument    
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Fibra Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

XX.XX - Realizar o Reagendamento via API
    [TAGS]                                  SCRIPT_COMPLETO
    Reagendar Pedido OPM e FSL              

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  SCRIPT_COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

167.10/12/14 - Realizar o Encerramento da OS de Instalação via FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global
    Validar Atribuicao Automatica Voip
    Atualiza Status SA
    Validar Estado do pedido FSL
    Atualizar e Encerrar a SA Voip          EQUIPAMENTO=ONT HW - HG8245H

167.11/13/15 - Validar Mudança de Status do FSL no Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                           WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name

167.16 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_COMPLETO
    Auditoria de Tarefas                    

167.17 - Validar no Field Service
    [TAGS]                                  SCRIPT_COMPLETO
    Valida SA no Field Service
   
167.18 - Realizar Validação de Retorno via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Fibra Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

167.19 - Validar a Notificação de Encerramento no Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar Microserviços no menu do PORTAL de Microserviços
    Procurar por SingleNotificationManagement.SOM referente ao associatedDocument
    Validar texto do Bloco com o Argumento    Evento Origem SOM [API_TYPE: ProductOrdering][NOTIF_TYPE: StatusChange]       Ordem Encerrada com Sucesso para Banda Larga e VOIP OI
