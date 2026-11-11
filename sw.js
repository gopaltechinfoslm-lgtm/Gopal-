const C='gs-tv-v1';
const SHELL=['./','./index.html','./manifest.webmanifest','./icon.svg','https://cdn.jsdelivr.net/npm/hls.js@1.5.17/dist/hls.min.js'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>Promise.all(SHELL.map(u=>c.add(u).catch(()=>{})))).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',e=>{
  const u=e.request.url;
  if(e.request.method!=='GET'||/\.(m3u8|ts|m4s|mp4)(\?|$)/.test(u)||u.startsWith('blob:'))return;
  e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request).then(n=>{if(n.ok&&(u.startsWith(self.location.origin)||u.includes('cdn.jsdelivr.net'))){const cp=n.clone();caches.open(C).then(c=>c.put(e.request,cp))}return n}).catch(()=>caches.match('./index.html'))));
});
