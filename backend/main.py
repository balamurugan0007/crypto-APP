from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import httpx

app = FastAPI(title="Crypto App Backend")

# Allow Flutter to call this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

COINGECKO_BASE = "https://api.coingecko.com/api/v3"


@app.get("/")
def root():
    return {"message": "Crypto App Backend is running!"}


@app.get("/coins")
async def get_coins(page: int = 1, per_page: int = 20):
    """Get list of coins with market data"""
    url = f"{COINGECKO_BASE}/coins/markets"
    params = {
        "vs_currency": "usd",
        "order": "market_cap_desc",
        "per_page": per_page,
        "page": page,
        "sparkline": False,
        "price_change_percentage": "24h",
    }
    async with httpx.AsyncClient(timeout=10) as client:
        try:
            response = client.get(url, params=params)
            resp = await response
            resp.raise_for_status()
            return resp.json()
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))


@app.get("/coins/{coin_id}")
async def get_coin_detail(coin_id: str):
    """Get detailed info for a specific coin"""
    url = f"{COINGECKO_BASE}/coins/{coin_id}"
    params = {
        "localization": False,
        "tickers": False,
        "market_data": True,
        "community_data": False,
        "developer_data": False,
    }
    async with httpx.AsyncClient(timeout=10) as client:
        try:
            response = await client.get(url, params=params)
            response.raise_for_status()
            data = response.json()
            # Return only what we need
            return {
                "id": data["id"],
                "name": data["name"],
                "symbol": data["symbol"],
                "image": data.get("image", {}).get("large", ""),
                "description": data.get("description", {}).get("en", ""),
                "current_price": data["market_data"]["current_price"]["usd"],
                "market_cap": data["market_data"]["market_cap"]["usd"],
                "total_volume": data["market_data"]["total_volume"]["usd"],
                "price_change_24h": data["market_data"]["price_change_percentage_24h"],
                "price_change_7d": data["market_data"]["price_change_percentage_7d"],
                "price_change_30d": data["market_data"]["price_change_percentage_30d"],
                "high_24h": data["market_data"]["high_24h"]["usd"],
                "low_24h": data["market_data"]["low_24h"]["usd"],
                "circulating_supply": data["market_data"]["circulating_supply"],
                "total_supply": data["market_data"]["total_supply"],
                "market_cap_rank": data["market_cap_rank"],
                "ath": data["market_data"]["ath"]["usd"],
                "atl": data["market_data"]["atl"]["usd"],
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))


@app.get("/coins/{coin_id}/chart")
async def get_coin_chart(coin_id: str, days: int = 7):
    """Get price chart data for a coin"""
    url = f"{COINGECKO_BASE}/coins/{coin_id}/market_chart"
    params = {
        "vs_currency": "usd",
        "days": days,
    }
    async with httpx.AsyncClient(timeout=10) as client:
        try:
            response = await client.get(url, params=params)
            response.raise_for_status()
            data = response.json()
            # prices is a list of [timestamp, price]
            return {"prices": data["prices"]}
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))


@app.get("/search")
async def search_coins(query: str):
    """Search coins by name or symbol"""
    url = f"{COINGECKO_BASE}/search"
    params = {"query": query}
    async with httpx.AsyncClient(timeout=10) as client:
        try:
            response = await client.get(url, params=params)
            response.raise_for_status()
            data = response.json()
            # Return only coins, not exchanges/categories
            coins = data.get("coins", [])[:10]
            return {"coins": coins}
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))


@app.get("/global")
async def get_global_stats():
    """Get global crypto market stats"""
    url = f"{COINGECKO_BASE}/global"
    async with httpx.AsyncClient(timeout=10) as client:
        try:
            response = await client.get(url)
            response.raise_for_status()
            data = response.json().get("data", {})
            return {
                "total_market_cap": data.get("total_market_cap", {}).get("usd", 0),
                "total_volume": data.get("total_volume", {}).get("usd", 0),
                "market_cap_change_24h": data.get("market_cap_change_percentage_24h_usd", 0),
                "active_cryptocurrencies": data.get("active_cryptocurrencies", 0),
                "btc_dominance": data.get("market_cap_percentage", {}).get("btc", 0),
                "eth_dominance": data.get("market_cap_percentage", {}).get("eth", 0),
            }
        except Exception as e:
            raise HTTPException(status_code=500, detail=str(e))
