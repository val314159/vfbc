// app.js
const clog = console.log
const D=document
const TextNode = x=>D.createTextNode(x)
const Element = x=>D.createElement(x)
const GEBI = x=>D.getElementById(x)
const outElt = GEBI("out")
const taElt = GEBI("ta")
const out = x=>outElt.appendChild(TextNode(x+"\n"))
const origin = 'ws'+location.origin.substr(4)
//var ws = new WebSocket(origin+"/bongo")
var ws = new WebSocket(origin+"/pubsub")
ws.onmessage = e=>clog(["m",e])+out("<<"+e.data)
ws.onerror   = e=>clog(["e",e])
ws.onclose   = e=>clog(["c",e])
ws.onopen    = e=>clog(["o",e])
function grab(elt){
    const txt = elt.value
    elt.value = ""
    elt.focus()
    return txt}
GEBI("send").onclick=()=>{
    clog("send")
    const txt = grab(taElt)
    out(">>"+txt)
    ws.send(txt)}
