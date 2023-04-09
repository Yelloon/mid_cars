local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface(GetCurrentResourceName())
src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
local carModels = {"adder", "comet2", "bati", "t20", "vacca", "bullet", "carbonizzare", "entityxf", "zentorno", "cheetah", "penetrator", "reaper", "fmj", "osiris", "tempesta", "nero", "italigtb", "visione", "tyrus", "gp1", "torero", "xa21", "vagner", "tezeract", "krieger", "emerus", "sc1", "neon", "pariah", "khamelion"}
local isInService = false
local value = config.pagamento
local timer = nil
function spawnRandomCar()
  local carModel = carModels[math.random(#carModels)]
  RequestModel(carModel)
  while not HasModelLoaded(carModel) do
     Citizen.Wait(0)
  end
  local randomIndex = math.random(#config.locations)
  local spawnCoords = vector3(config.locations[randomIndex][1], config.locations[randomIndex][2], config.locations[randomIndex][3])
  local vehicle = CreateVehicle(carModel, spawnCoords, true, false)
  SetEntityAsMissionEntity(vehicle, true, true)
  SetVehicleNumberPlateText(vehicle, math.random(40000-20300))
  SetVehicleEngineHealth(vehicle, 0.3)
  for i = 0, 4 do
     SetVehicleDoorBroken(vehicle, i, true)
  end
  SetVehicleDoorsLocked(vehicle, 2)
  SetModelAsNoLongerNeeded(carModel)
  TriggerEvent("Notify","atencao","Um novo veículo foi localizado. Localização adicionada em seu GPS.",7000)
  SetNewWaypoint(spawnCoords)
  local vehicleRepaired = false -- Variável que indica se o veículo já foi consertado
  Citizen.CreateThread(function()
  local playerPed = GetPlayerPed(-1)
  while true do
     Citizen.Wait(0)
     local distance = GetDistanceBetweenCoords(GetEntityCoords(playerPed), spawnCoords, true)
     if distance < 3.0 then
        if not vehicleRepaired then -- Verifica se o veículo ainda não foi consertado
           drawTxt("PRESSIONE ~r~E~w~ PARA CONSERTAR O VEICULO", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
           if IsControlJustReleased(0, 38) then -- 38 é o código do botão 'E'
              print("A")
              RequestAnimDict("mini@repair") -- Carrega o dicionário de animação
              while not HasAnimDictLoaded("mini@repair") do
                 Citizen.Wait(0)
              end
              TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 8.0, -8.0, -1, 0, 0, false, false, false)
              Citizen.Wait(6000) -- Aguarda 6 segundos
              SetVehicleFixed(vehicle)
              ClearPedTasksImmediately(playerPed) -- Interrompe a animação
              vehicleRepaired = true -- Define a variável como verdadeira após consertar o veículo
              TriggerServerEvent("vrp_blue:receber",value)
              TriggerEvent("Notify","sucesso","Pagamento depositado. Você recebeu "..value.. "" ,7000)
           end
        else
           drawTxt("O VEÍCULO JÁ FOI CONSERTADO", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
        end
     end
  end
  end)
end
Citizen.CreateThread(function()
  local markerPos = config.start
  while true do
      Citizen.Wait(0)
      DrawMarker(27, markerPos.x, markerPos.y, markerPos.z - 0.90, 0, 0, 0, 0, 0, 0, 3.0, 3.0, 1.0, 222, 67, 11, 40, 0, 0, 0, 1)
      local playerPed = GetPlayerPed(-1)
      local playerCoords = GetEntityCoords(playerPed)
      local distance = GetDistanceBetweenCoords(playerCoords, markerPos, true)
      if distance <= 3.0 then
          if isInService then
              drawTxt("PRESSIONE ~r~E~w~ PARA SAIR DO SERVIÇO", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
          else
              drawTxt("PRESSIONE ~r~E~w~ PARA ENTRAR EM SERVIÇO", 4, 0.5, 0.93, 0.50, 255, 255, 255, 180)
          end
          if IsControlJustPressed(1, 38) then
            startService()
          end
      end
  end
end)
function startService()
  if isInService then
    TriggerEvent("Notify","sucesso","Você saiu de serviço.",7000)
    isInService = false
    if timer then
      Citizen.KillTimer(timer)
      timer = nil
    end
  else
    TriggerEvent("Notify","sucesso","Você entrou de serviço.",7000)
    isInService = true
    timer = Citizen.CreateThread(function()
      while isInService do
        spawnRandomCar()
        Citizen.Wait(config.time)
      end
    end)
  end
end
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
