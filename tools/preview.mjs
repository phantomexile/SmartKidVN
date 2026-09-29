// Máy chủ chỉ đọc thư mục bản dựng Flutter; từ chối đường dẫn vượt khỏi thư mục đó.
import http from 'node:http';
import {readFile, stat} from 'node:fs/promises';
import path from 'node:path';
const root = path.resolve('build/web');
const mime = {'.html':'text/html; charset=utf-8','.js':'application/javascript; charset=utf-8','.json':'application/json; charset=utf-8',
  '.wasm':'application/wasm','.png':'image/png','.ttf':'font/ttf','.otf':'font/otf','.css':'text/css; charset=utf-8'};
http.createServer(async (req,res) => {
  try {
    const name = decodeURIComponent(new URL(req.url,'http://localhost').pathname);
    let file = path.resolve(root, '.' + name);
    if (file !== root && !file.startsWith(root + path.sep)) {res.writeHead(403);res.end();return;}
    if ((await stat(file)).isDirectory()) file = path.join(file,'index.html');
    res.writeHead(200,{'Content-Type':mime[path.extname(file)] ?? 'application/octet-stream','Cache-Control':'no-store'});
    res.end(await readFile(file));
  } catch {res.writeHead(404);res.end('Not found');}
}).listen(4173,'127.0.0.1',() => console.log('SmartKidVN: http://127.0.0.1:4173'));
