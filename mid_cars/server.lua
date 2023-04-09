local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")

------------------------------------------------------------------------------------------------------
--FUNÇÕES
------------------------------------------------------------------------------------------------------

RegisterServerEvent('vrp_blue:receber')
AddEventHandler('vrp_blue:receber',function(pagamento)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if config.Base == "creative" then 
            vRP.addBank(user_id,parseInt(pagamento))
        elseif config.Base == "bahamas" then 
            vRP.addBank(user_id,parseInt(pagamento))
        elseif config.Base == "vrpex" then 
            vRP.giveMoney(user_id,parseInt(pagamento))
        else 
            print("Pagamento não foi confirmado pois a configuração de base esta incorreta!")
        end 
        TriggerClientEvent("vrp_sound:source",source,'dinheiro',0.3)
    end
end)