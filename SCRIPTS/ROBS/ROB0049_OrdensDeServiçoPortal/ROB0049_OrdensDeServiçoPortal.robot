*** Settings ***
Documentation                               Scripts da página de Ordens de Serviço do Portal.

Resource                                    ../../RESOURCE/COMMON/RES_UTIL.robot

Resource                                    ../../RESOURCE/PORTAL/PAGE_OBJECTS.robot
Library                                     RPA.Browser.Selenium
Library                                     Browser

*** Keywords ***

Criar Ordem de Serviço de ${tipoDeOrdem} com ${tipoViabilidade} e velocidade ${velocidade}MBPS

    ${cep}=                             Ler Variavel na Planilha      address              Global
    ${numero}=                          Ler Variavel na Planilha      number               Global
    ${reference}=                       Ler Variavel na Planilha      reference            Global
    ${nome}=                            Ler Variavel na Planilha      customerName         Global
    ${phoneNumber}=                     Ler Variavel na Planilha      phoneNumber          Global
    ${typeComplement}=                  Ler Variavel na Planilha      typeComplement       Global
    ${valueComplement}=                 Ler Variavel na Planilha      value                Global
    ${casaIdDAT}=                       Ler Variavel na Planilha      casaId               Global

    ${osOwner}=                         Browser.Get Text              xpath=//header//div[@class="text-left text-grey-9 q-pr-md"]//div[1]        
    Browser.Click                       ${novaOS}
    Browser.Click                       ${selectTipoOrdem}    
    Browser.Click                       xpath=//div[@class="q-item__label"][contains(text(),"${tipoDeOrdem}")]        
    Browser.Click                       ${caixaEndereco}
    Browser.Fill Text                   ${inputCEP}                   ${cep}
    
    #--- Cenário sem número de residência
    IF    "${numero}" == "SN"
        Browser.Click                   xpath=//div[@class="q-toggle__thumb absolute flex flex-center no-wrap"]
    ELSE
        Browser.Fill Text               ${inputNumero}                ${numero} 
    END
    
    Browser.Take Screenshot          
    
    #--- Step Consulta de Logradouro
    Browser.Click                       ${buttonBuscar}
    Browser.Click                       ${resultadoEndereco}
    
    IF    "${typeComplement}" != "None"
        Browser.Click                   xpath=(//input[@aria-label="Selecione o tipo"]/../../../..//i[@role="presentation"])[1]
        ${sucessComp}=                  Run Keyword And Return Status                Browser.Click                                                            xpath=//div[@class="q-item__label"][contains(text(),"${typeComplement}")]     
        IF    "${sucessComp}" != "True"
            Fatal Error                 msg=O complemento não foi encontrado dentro das opções. Verifique as opções no site e tente novamente.
        END
        IF    "${valueComplement}" != "None"
            Browser.Click               xpath=(//input[@aria-label="Selecione o complemento"]/../../../..//i[@role="presentation"])[1]                        
            ${sucessVal}=               Run Keyword And Return Status                Browser.Click                                                            xpath=//div[@class="q-item__label"][contains(text(),"${valueComplement}")]     
            IF    "${sucessComp}" != "True"
                Fatal Error             msg=O valor do complemento não foi encontrado dentro das opções. Verifique as opções no site e tente novamente.
            END 
        END
    END
    
    #--- Step Consulta de Viabilidade
    Browser.Fill Text                   ${inputReferencia}            ${reference}
    Browser.Click                       ${buttonViabilidade}
    Browser.Get Text                    xpath=//div[contains(text(),"${tipoViabilidade}")]                           message=${tipoViabilidade} Não Confirmada!
    Browser.Take Screenshot
    
    #--- Step Realizar Agendamento
    Browser.Click                       ${buttonAgenda}
    Browser.Wait For Elements State     xpath=(//div[@class="self-center"][contains(text(),"Disponível")])[1]        visible
    Browser.Click                       xpath=(//div[@class="self-center"][contains(text(),"Disponível")])[1]
    Browser.Fill Text                   xpath=//textarea[@type="textarea"]                                           ${tipoDeOrdem}     
    Browser.Click                       xpath=//span[@class="block"][contains(text(),"Confirmar")]
    
    #-- Step Criação de Ordem
    Browser.Fill Text                   ${inputNome}                                                                 ${nome}
    Browser.Fill Text                   ${inputCelular}                                                              ${phoneNumber}
    Browser.Fill Text                   ${inputCasaId}                                                               ${casaIdDAT}
    Browser.Take Screenshot
    Browser.Click                       xpath=//div[@class="q-px-lg q-py-md q-card"]//div[contains(text(),"${velocidade} Mbps")]/../..//span[contains(text(),"Selecionar")]
    Browser.Click                       xpath=//span[@class="block"][contains(text(),"Salvar")]
    
    #-- Validações da Ordem criada
    Browser.Click                       xpath=(//td[@class="cursor-pointer q-td text-center"][contains(text(),"${osOwner}")])[1]/..
    ${casaId}=                          Browser.Get Text                    xpath=(//span[contains(text(),"ID")])[3]/..//div//span
    ${portalOsId}=                      Browser.Get Text                    xpath=(//span[contains(text(),"OS")])/..//div//span
    ${aux}=                             Browser.Get Text                    ${linkDataAgendamento}
    Validar status Aberta da Ordem de Serviço
    Browser.Take Screenshot
    ${dataAgendamento}=                 Split String                        ${aux}

    Escrever Variavel na Planilha       ${dataAgendamento[0]}               dataAgendamento                          Global
    Escrever Variavel na Planilha       ${portalOsId}                       portalOsId                               Global

    Should Be Equal As Strings          ${casaId}                           ${casaIdDAT}
####################################################################################################################################################
Pesquisar OS ID em Ordens de Serviço   
    ${portalOsId}=                      Ler Variavel na Planilha        portalOsId                        Global
    Browser.Fill Text                   ${searchId}                         ${portalOsId}
    Browser.Wait For Elements State     xpath=//td[contains(text(),"${portalOsId}")]/..                   visible
    Browser.Take Screenshot
####################################################################################################################################################
Validar status ${valorEstado} da Ordem de Serviço 
    
    Browser.Get Text                    xpath=//span[contains(text(),"Detalhes da ordem de serviço")]/../../..//span[contains(text(),"Status")]/../..//span[contains(text(),"${valorEstado}")]                message=Status da ordem diferente está ${valorEstado}

####################################################################################################################################################
Consultar Historico de Agendamento da OS no PORTAL
    
    ${portalOsId}=                      Ler Variavel na Planilha        portalOsId                        Global
    ${casaId}=                          Ler Variavel na Planilha        casaId                            Global
    ${dataPlanilha}=                    Ler Variavel na Planilha        dataAgendamento                   Global
    ${customerName}=                    Ler Variavel na Planilha        customerName                      Global
    
    Pesquisar OS ID em Ordens de Serviço
    Browser.Click                       ${linkDataAgendamento}
    Browser.Get Text                    xpath=//div[contains(text(),"ID da Casa Conectada: ${casaId}")]/../../..            message=ID da Casa diferente do esperado.
    Browser.Wait For Elements State     xpath=//div[@class="q-item__label"]                               visible
    Browser.Click                       xpath=//div[@class="q-item__label"]
    Browser.Take Screenshot
    ${dataAgendamento}=                 Browser.Get Text                xpath=(//div[contains(text(),"Data Agendamento")]/..//div)[2]            
    ${detalhesOs}=                      Browser.Get Text                xpath=//span[contains(text(),"Detalhes do agendamento")]/../../..//div[contains(text(),"O.S. ${portalOsId}")]                message= Portal OS ID está diferente.
    ${detalhesId}=                      Browser.Get Text                xpath=//span[contains(text(),"Detalhes do agendamento")]/../../..//div[contains(text(),"${casaId}")]                         message= ID da casa está diferente.
    ${detalhesNome}=                    Browser.Get Text                xpath=//span[contains(text(),"Detalhes do agendamento")]/../../..//div[contains(text(),"${customerName}")]                   message= Nome do cliente está diferente.
    
    Should Be Equal As Strings          ${dataAgendamento}              ${dataPlanilha}  


####################################################################################################################################################
Realizar cancelamento da Ordem no PORTAL
    
    ${portalOsId}=                      Ler Variavel na Planilha        portalOsId                        Global
    
    Pesquisar OS ID em Ordens de Serviço
    Browser.Click                       ${botaoCirculoAmarelo}
    Browser.Wait For Elements State     ${botaoCirculoCancelar}         visible
    Browser.Click                       ${botaoCirculoCancelar}
    Browser.Get Text                    xpath=//div[contains(text(),"Deseja cancelar a O.S. ${portalOsId}?")]            message= ATENÇÃO: Foi selecionada a Ordem ERRADA!
    Browser.Click                       xpath=//span[@class="block"][contains(text(),"Confirmar")]
    Pesquisar OS ID em Ordens de Serviço

    ${success}=                         Run Keyword And Return Status            Validar status Cancelada da Ordem de Serviço
    
    WHILE    "${success}" != "True"
        Sleep    4000
        Pesquisar OS ID em Ordens de Serviço
        ${success}=                     Run Keyword And Return Status            Validar status Cancelada da Ordem de Serviço
    END