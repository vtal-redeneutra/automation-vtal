*** Settings ***
Documentation                               Agrupador responsavel por chamar TC dos ROBS referentes ao cenario
...                                         INPUT: Address, Customer_Name, Phone_Number, Reference, 
...                                         OUTPUT: Address_Id, TypeComplement1, Value1, TypeComplement2, Value2, TypeComplement3, Value3,

Resource                                    ../../../RESOURCE/COMMON/RES_UTIL.robot
Resource                                    ../../../RESOURCE/FW/UTILS.robot
Resource                                    ../../../RESOURCE/API/RES_API.robot
Resource                                    ../../../RESOURCE/MS/UTILS.robot

Suite Setup                                 Setup cenario                           Bitstream

Resource                                    ${DIR_FSL}/UTILS.robot
Resource                                    ${DIR_SOM}/UTILS.robot


Resource                                    ${DIR_ROBS}/ROB0001_ConsultarIdEndereco/ROB0001_ConsultarIdEndereco.robot
Resource                                    ${DIR_ROBS}/ROB0002_ConsultarViabilidade/ROB0002_ConsultarViabilidade.robot
Resource                                    ${DIR_ROBS}/ROB0003_ConsultarSlot/ROB0003_ConsultarSlot.robot
Resource                                    ${DIR_ROBS}/ROB0004_RealizarAgendamento/ROB0004_RealizarAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0005_CriarOrdemAgendamento/ROB0005_CriarOrdemAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0007_ValidarAtribuicaoCompromissoFSL/ROB0007_ValidarAtribuicaoCompromissoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0018_TratarPendenciaSOM/ROB0018_TratarPendenciaSOM.robot
Resource                                    ${DIR_ROBS}/ROB0025_AtualizacaoDeAgendamento/ROB0025_AtualizacaoDeAgendamento.robot
Resource                                    ${DIR_ROBS}/ROB0026_TrocaDeTecnicoFSL/ROB0026_TrocaDeTecnicoFSL.robot
Resource                                    ${DIR_ROBS}/ROB0010_ValidarSAFieldService/ROB0010_ValidarSAFieldService.robot
Resource                                    ${DIR_MOBS}/MOB0001_EncerrarSaOPM/MOB0001_EncerrarSaOPM.robot
Resource                                    ${DIR_ROBS}/ROB0027_DesatribuirAtividadeFSL/ROB0027_DesatribuirAtividadeFSL.robot
Resource                                    ${DIR_ROBS}/ROB0009_EncerrarAtualizarSA/ROB0009_EncerrarAtualizarSA.robot



*** Variables ***
${DAT_CENARIO}                              ${DIR_DAT}/150_AtivacaoBitMultiplosComplementosResolucaoPendenciaOPM.xlsx

*** Test Cases ***
150.01 - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_A
    Retornar Token Vtal

150.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_A
    Consulta Id Logradouro

150.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_A
    Retorna Viabilidade dos Produtos Bitstream

150.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_A
    Consulta Slot Agendamento

150.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_A
    Realizar Agendamento

150.07 - Validar a Notificação do Agendamento via Microserviços
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML     END - Finalização do serviço    tns:code                                201

150.08 - Validar agendamento no FSL
    [TAGS]                                  SCRIPT_A
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Close Browser                           CURRENT

150.09 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_A
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400  
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

150.10 - Validar a Notificação da Criação da Ordem (OS) via Microserviços
    [TAGS]                                  SCRIPT_A
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por WorkOrderManagement.NotificationCreatedOrder referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     tns:code                                200

    Validar FW Ordem Bitstream              VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderInProvisioning'])[1]

150.11 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument                                                         

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

150.12 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    [TAGS]                                  SCRIPT_A
    Resolucao pendencia Tenant

150.13 - Validar a atualização da tarefa via SOM
    [TAGS]                                  SCRIPT_A
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument        
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

150.14 - Validação FSL
    [TAGS]                                  SCRIPT_A
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  SCRIPT_A
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

#===================================================================================================================================================================
XX.XX - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_B
    Retornar Token Vtal

150.15/17/19 - Realizar o Encerramento da OS de Instalação via OPM
    [TAGS]                                  SCRIPT_B
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Close Browser     
    Colocar Sa Concluida sem sucesso
    Valida sucesso do equipamento no FSL
    Encerrar SA sem sucesso OPM             codigo_encerramento=7111
 
150.16/18/20 - Validar Mudança de Status do FSL no Microserviços
    [TAGS]                                  SCRIPT_B
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderInformationRequiredEvent referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado ao API Gateway                                  msg:Description                         VERIFICAR BACKBONE TENANT

150.21 - Validar no Field Service
    [TAGS]                                  SCRIPT_B
    Valida SA no Field Service
   
150.22 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_B
    Auditoria de Tarefas                    estado_encerramento=Concluído sem sucesso

150.23 - Realizar Validação de Pendência 7111 via SOM
    [TAGS]                                  SCRIPT_B
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument        
    
    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Tratar Pendência Tenant
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50
  
150.24 - Realizar resolução da pendência (7111)
    [TAGS]                                  SCRIPT_B
    Fechar pendencia de rede 7111

150.25 - Realizar Validação de Pendência 7111 via SOM
    [TAGS]                                  SCRIPT_B
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

150.26 - Validar Encerramento no Microserviços
    [TAGS]                                  SCRIPT_B
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderInformationRequiredEvent referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado ao API Gateway                                  msg:Description                         Ordem Encerrada com Sucesso

#===================================================================================================================================================================
150.01 - Gerar Token de Acesso 
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Token Vtal

150.02/03 - Realizar Consulta de Logradouro
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Id Logradouro

150.04 - Realizar Consulta de Viabilidade
    [TAGS]                                  SCRIPT_COMPLETO
    Retorna Viabilidade dos Produtos Bitstream

150.05 - Realizar Consulta de Slots
    [TAGS]                                  SCRIPT_COMPLETO
    Consulta Slot Agendamento

150.06 - Realizar o Agendamento
    [TAGS]                                  SCRIPT_COMPLETO
    Realizar Agendamento

150.07 - Validar a Notificação do Agendamento via Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por Appointment.PostAppointment referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML     END - Finalização do serviço    tns:code                                201

150.08 - Validar agendamento no FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Close Browser                           CURRENT

150.09 - Realizar a Criação de Ordem (OS)
    [TAGS]                                  SCRIPT_COMPLETO
    Criar Ordem Agendamento Bitstream       VELOCIDADE=400  
    Escrever Variavel na Planilha           Atribuído                               Estado                                  Global

150.10 - Validar a Notificação da Criação da Ordem (OS) via Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por WorkOrderManagement.NotificationCreatedOrder referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    END - Finalização do serviço     tns:code                                200

    Validar FW Ordem Bitstream              VALOR_BUSCA=associatedDocument
    ...                                     XPATH_EVENTO=(//a[normalize-space()='ProductOrdering.ListenerProductOrderInProvisioning'])[1]

150.11 - Validar a Criação da OS de Instalação via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument    

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Notificar Recursos Tenant	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     TIPO_PESQUISA=PREVIEW
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}

150.12 - Atualização do patch de tarefa “TA - Notificar Recursos Tenant”
    [TAGS]                                  SCRIPT_COMPLETO
    Resolucao pendencia Tenant

150.13 - Validar a atualização da tarefa via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument        

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=T017 - Instalar Equipamento	
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50

150.14 - Validação FSL
    [TAGS]                                  SCRIPT_COMPLETO
    Escrever Variavel na Planilha           Não atribuído                           Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL

XX.XX - Realizar o Reagendamento via API
    [TAGS]                                  SCRIPT_COMPLETO
    Retornar Token Vtal
    Reagendar Pedido OPM e FSL              

XX.XX - Atribuir técnico no Field Service 
    [TAGS]                                  SCRIPT_COMPLETO
    Troca de Tecnico no Field Service
    Close Browser                           CURRENT

150.15/17/19 - Realizar o Encerramento da OS de Instalação via OPM
    [TAGS]                                  SCRIPT_COMPLETO
    Colocar SA em execucao
    Escrever Variavel na Planilha           Em execução                             Estado                                  Global
    Validar Atribuicao Automatica Bitstream FSL
    Close Browser     
    Colocar Sa Concluida sem sucesso
    Valida sucesso do equipamento no FSL
    Encerrar SA sem sucesso OPM             codigo_encerramento=7111
 
150.16/18/20 - Validar Mudança de Status do FSL no Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    ${state_list}=                          Create List                             EN_ROUTE                                IN_EXECUTION                            ACTIVITY_CONCLUDED_SUCESSFULLY
    
    Validar Mudanca de Estados no Portal de Microserviços                           associatedDocument                      ${state_list}                            WorkOrderManagement.ListenerWorkOrderStateChangeEvent                          tns:name      

    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderInformationRequiredEvent referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado ao API Gateway                                  msg:Description                         VERIFICAR BACKBONE TENANT

150.21 - Validar no Field Service
    [TAGS]                                  SCRIPT_COMPLETO
    Valida SA no Field Service
   
150.22 - Auditoria de Tarefas
    [TAGS]                                  SCRIPT_COMPLETO
    Auditoria de Tarefas                    estado_encerramento=Concluído sem sucesso

150.23 - Realizar Validação de Pendência 7111 via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    @{LIST}=                                Create List                             ${SOM_Ordem_numeroPedido}                        

    @{RETORNO}=                             Create List                             associatedDocument        

    Validar Evento Completo SOM             VALOR_PESQUISA=associatedDocument
    ...                                     TASK_NAME=TA - Tratar Pendência Tenant
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação	
    ...                                     ORDER_STATE=In Progress
    ...                                     RETORNO_ESPERADO=${RETORNO}
    ...                                     XPATH_VALIDACOES=${LIST}
    ...                                     TENTATIVAS_FOR=50
  
150.24 - Realizar resolução da pendência (7111)
    [TAGS]                                  SCRIPT_COMPLETO
    Fechar pendencia de rede 7111

150.25 - Realizar Validação de Pendência 7111 via SOM
    [TAGS]                                  SCRIPT_COMPLETO
    Validar Evento Simples SOM              VALOR_PESQUISA=associatedDocument
    ...                                     ORDER_TYPE=Vtal Bitstream Instalação
    ...                                     ORDER_STATE=Completed
    Close Browser                           CURRENT

150.26 - Validar Encerramento no Microserviços
    [TAGS]                                  SCRIPT_COMPLETO
    Login ao Portal de Microserviços
    Acessar SOA no menu do PORTAL de Microserviços
    Procurar por ProductOrdering.ListenerProductOrderInformationRequiredEvent referente ao associatedDocument
    Validar dado do Bloco com o Argumento   XML    INVOKE - Request enviado ao API Gateway                                  msg:Description                         Ordem Encerrada com Sucesso

