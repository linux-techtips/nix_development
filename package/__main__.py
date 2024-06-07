from fastapi.responses import HTMLResponse
from fastapi import FastAPI
import uvicorn


app = FastAPI()


@app.get('/', response_class=HTMLResponse)
async def root() -> str:
   return '''
    <html>
        <head>
            <title>SupplyPay</title>
        </head>
        <body>
            <h1>Haha, all your sanity is belong to me!!!</h1>
        </body>
    </html>
   ''' 


@app.get('/data')
async def data() -> dict:
    return {
        'json data': {
            'some_number': 10,
            'some_string': 'lol',
            'null': None,
        },
    }


if __name__ == '__main__':
    uvicorn.run(f'{__name__}:app', host='0.0.0.0', port=8000, log_level='info')
