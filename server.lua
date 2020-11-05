local Config = {
    apikey = "APIKEY_HERE",
    city = "London",
    refreshTime = 10 * 60000, --min
}

local weatherType, windSpeed, windDirection

local apiString = "http://api.weatherapi.com/v1/current.json?key=" .. Config.apikey .. "&q=" .. Config.city


Citizen.CreateThread(function()
    while true do
    syncWeather()
    Citizen.Wait(Config.refreshTime)
    end
end)

RegisterServerEvent('luck-weathersync:server:syncWeather')
AddEventHandler('luck-weathersync:server:syncWeather', function()
    TriggerClientEvent('luck-weathersync:client:setWeather', source, windSpeed, windDirection, weatherType)
end)

function syncWeather()
    PerformHttpRequest(apiString, function (errorCode, resultData, resultHeaders)
        weatherType = json.decode(resultData).current.condition.code
        windSpeed = json.decode(resultData).current.wind_mph
        windDirection = json.decode(resultData).current.wind_degree
        TriggerClientEvent('luck-weathersync:client:setWeather', -1, windSpeed, windDirection, weatherType)
    end)
end
