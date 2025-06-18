import requests

# https://restapi.amap.com/v3/weather/weatherInfo?key=bee5a13244b74f48fbd3f2a05b48ed14&city=350200&extensions=all
# eg:
# ?{
#   "status": "1",
#   "count": "1",
#   "info": "OK",
#   "infocode": "10000",
#   "forecasts": [
#     {
#       "city": "厦门市",
#       "adcode": "350200",
#       "province": "福建",
#       "reporttime": "2025-05-08 06:33:52",
#       "casts": [
#         {
#           "date": "2025-05-08",
#           "week": "4",
#           "dayweather": "小雨",
#           "nightweather": "小雨",
#           "daytemp": "27",
#           "nighttemp": "21",
#           "daywind": "北",
#           "nightwind": "北",
#           "daypower": "1-3",
#           "nightpower": "1-3",
#           "daytemp_float": "27.0",
#           "nighttemp_float": "21.0"
#         },
#         {
#           "date": "2025-05-09",
#           "week": "5",
#           "dayweather": "小雨",
#           "nightweather": "阴",
#           "daytemp": "30",
#           "nighttemp": "23",
#           "daywind": "北",
#           "nightwind": "北",
#           "daypower": "1-3",
#           "nightpower": "1-3",
#           "daytemp_float": "30.0",
#           "nighttemp_float": "23.0"
#         },
#         {
#           "date": "2025-05-10",
#           "week": "6",
#           "dayweather": "小雨",
#           "nightweather": "小雨",
#           "daytemp": "27",
#           "nighttemp": "22",
#           "daywind": "北",
#           "nightwind": "北",
#           "daypower": "1-3",
#           "nightpower": "1-3",
#           "daytemp_float": "27.0",
#           "nighttemp_float": "22.0"
#         },
#         {
#           "date": "2025-05-11",
#           "week": "7",
#           "dayweather": "多云",
#           "nightweather": "多云",
#           "daytemp": "28",
#           "nighttemp": "19",
#           "daywind": "北",
#           "nightwind": "北",
#           "daypower": "1-3",
#           "nightpower": "1-3",
#           "daytemp_float": "28.0",
#           "nighttemp_float": "19.0"
#         }
#       ]
#     }
#   ]
# }

api_key = "bee5a13244b74f48fbd3f2a05b48ed14"
city = "350200" # 厦门市

def get_weather(city):
    url = f"https://restapi.amap.com/v3/weather/weatherInfo?key={api_key}&city={city}&extensions=all"
    response = requests.get(url)
    return response.json()

def get_today_weather(city):
    weather_data = get_weather(city)
    today_weather = weather_data["forecasts"][0]["casts"][0]
    return today_weather

def get_tomorrow_weather(city):
    weather_data = get_weather(city)
    tomorrow_weather = weather_data["forecasts"][0]["casts"][1]
    return tomorrow_weather


print(get_today_weather(city))