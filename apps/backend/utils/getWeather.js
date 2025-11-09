import dotenv from "dotenv";
dotenv.config();

const API_KEY = process.env.WEATHER_API_KEY;
const cache = new Map();
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

export const getWeather = async ({ city, lat, lon }) => {
  try {
    if (!API_KEY) throw new Error("Missing WeatherAPI key");

    const query = city ? city : `${lat},${lon}`;
    const cacheKey = query.toLowerCase();

    const cached = cache.get(cacheKey);
    if (cached && Date.now() - cached.timestamp < CACHE_DURATION) {
      console.log("⚡ Using cached WeatherAPI data");
      return cached.data;
    }

    const url = `https://api.weatherapi.com/v1/current.json?key=${API_KEY}&q=${query}&aqi=no`;
    const res = await fetch(url);
    const data = await res.json();

    if (!data || !data.current) throw new Error(data.error?.message || "Invalid WeatherAPI response");

    const weatherData = {
      location: data.location.name,
      temperature: data.current.temp_c,
      humidity: data.current.humidity,
      wind_speed: data.current.wind_kph,
      pressure: data.current.pressure_mb,
      rain_probability: data.current.precip_mm > 0 ? "Likely" : "None",
      last_updated: data.current.last_updated,
    };

    cache.set(cacheKey, { data: weatherData, timestamp: Date.now() });

    console.log(`✅ Fetched weather for ${weatherData.location}`);
    return weatherData;
  } catch (err) {
    console.error("❌ WeatherAPI error:", err.message);
    return { error: err.message };
  }
};
