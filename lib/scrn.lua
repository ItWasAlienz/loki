--screen stuff
UI = require("ui") ply = UI.PlaybackIcon.new(8,7,8,4)
function redraw()
  screen.clear() screen.aa(1) screen.move(1,1) 
  if params:get("InMon")==1 then screen.level(15) else screen.level(2) end screen.circle(2,2,0.5) screen.stroke()
  screen.level(1) screen.rect(86,3,44,15) screen.close() screen.fill() screen.stroke()
  screen.font_face(22) screen.move(88,14) screen.font_size(11) 
  if page==1 then screen.level(15) else screen.level(0) end screen.text("LO") screen.move(106,14)
  if page==2 then screen.level(15) else screen.level(0) end screen.font_size(13) screen.text("|") screen.move(111,14) 
  if page==3 then screen.level(15) else screen.level(0) end screen.font_size(11) screen.text("KI")
  screen.font_face(1) screen.font_size(8)
  if page==1 then
    hilite(sel,-9) mcs(48,59,48,59,0.5+(params:get("AT1")*0.5))
    hilite(sel,-8) mcs(52,59,52,59,0.5+(params:get("AT2")*0.5)) hilite(sel,-7) mtmt(56,62,"thrsh:",81,62,params:get("ATr"))
    hilite(sel,-6) mcs(114,59,114,59,0.5+(params:get("PT1")*0.5))
    hilite(sel,-5) mcs(122,59,122,59,0.5+(params:get("PT2")*0.5))
    hilite(sel,-4) mcs(118,62,118,62,0.5+(params:get("S_PRz")*0.5)) 
    hilite(sel,-3) mcs(127,59,127,59,0.5+(prmfreez*0.5)) hilite(sel,-2) mcs(127,62,127,62,0.5+(lrn*0.5)) 
    screen.move(25,12) hilite(sel,0) screen.text("tempo: "..params:get("clock_tempo"))
    hilite(sel,1) screen.move(25,20)
    if swuiflag == 1 then screen.text("swidth: "..params:get("Swdth")) else screen.text("swing: "..params:get("Swng")) end
    hilite(sel,2) screen.move(8,30)
    if params:get("Fxv")>0 then screen.text("fxv: "..params:get("Fxvc").." ON") 
    else screen.text("fxv: "..params:get("Fxvc").." OFF") end hilite(sel,3) screen.move(8,38)
    screen.text("Dir#"..fildrsel..":") screen.move(8,46)
    screen.text(util.trim_string_to_width(string.sub(fildir[fildrsel], 21, string.match(fildir[fildrsel], "^.*()/")),50))
    hilite(sel,24) screen.move(4,60) screen.text("Pre#:"..sprenum) mcs(2,58,2,58,0.5+(spr*0.5)) hilite(sel,25) 
    screen.move(32,58) screen.text("M:"..params:get("MPre")) screen.level(5)
    for k=1,4 do
      screen.font_size(8) screen.font_face(1)
      hilite(sel,k+3) screen.move(60,(k*8)+21) screen.text(params:get("S"..k.."_Svl")) hilite(sel,k+7)
      if params:get("S"..k.."_Dfl")>0 then mcs(74,(k*8)+19,74,(k*8)+19,2) else mcs(74,(k*8)+19,74,(k*8)+19,1) end 
      hilite(sel,k+11) screen.move(80,(k*8)+21) 
      screen.text((#seq[k]+params:get("S"..k.."_Sln"))) 
      hilite(sel,k+15) screen.move(95,(k*8)+19)
      if params:get("S"..k.."_Stt")==2 then screen.circle(94,(k*8)+19,2) 
      elseif params:get("S"..k.."_Stt")==1 then screen.circle(94,(k*8)+19,1) 
      else screen.circle(94,(k*8)+19,0.2) end screen.stroke()
      hilite(sel,k+19) screen.move(100,(k*8)+21)
      if params:get("S"..k.."_Rct")>0 then screen.font_face(20) else screen.font_face(1) end screen.text("F"..k) --ran cutoff
      screen.stroke()
    end 
  elseif page==2 then seqpg(spel)
  else softcutv(vsel,hsel) end ply:redraw() screen.update() rdrw=0
end

function seqpg(slct)
  screen.level(5) 
    for k=1,4 do
      if (k==((slct%4)+1)) and ((slct<4) and (slct>-1)) then
        if edit==1 then 
          screen.move(2,(k*8)+19) screen.font_size(8) screen.font_face(2) screen.text("E") screen.font_face(1) 
        else screen.font_size(8) screen.move(2,(k*8)+19) screen.text(">") end
      end screen.font_face(1)
      if (((slct)%4)+1 > 0) and (((slct)%4)+1 < 5) and fil>0 then screen.move(5,(k*8)+19) screen.text(files[k][selct[k]])
      else
        local slen=params:get("S"..k.."_Sln")
        for i=1,util.clamp((#seq[k]+slen),1,16) do
          for g = 1,16 do
            if edit==0 then
              local hindx = util.wrap(tix,1,#seq[k]+slen)
              if params:get("S"..k.."_Ply")>0 then hilite(hindx,(g+(uipag*16))) else screen.level(2) end
            else 
              if ((sl==(g+(uipag*16))) and ((slct+1)==k)) then screen.level(15) 
                else if params:get("S"..k.."_Ply")>0 then screen.level(5) else screen.level(2) end end 
            end
            if (g+(uipag*16)) <= (#seq[k]+slen) then screen.move(1+(g*7.4),(k*8)+19) screen.text(seq[k][g+(uipag*16)]) end
    end end end end
    screen.move(5,60) hilite(slct,4) screen.text(uipag+1)
    screen.move(15,60) hilite(slct,5) screen.text("Dir#"..fildrsel..":") screen.move(40,60)
    screen.text(string.sub(fildir[fildrsel], 21, string.match(fildir[fildrsel], "^.*()/")))
end

function softcutv(vs,hs)
  local countess=voices[vs].tixx hilite(hs,-1) mcs(11,58,11,58,(vpr*0.5)+0.5)
  screen.font_size(8) screen.move(15,60) screen.text("Preset#")
  screen.font_size(10) screen.move(51,61) screen.text(vprenum) screen.font_size(8)
  hilite(hs,1) mcs(24,11,24,11,0.5) hilite(hs,2) screen.rect(27,7,8,9) screen.move(29,14) 
  screen.text(vs) mcs(38,11,38,11,0.5+(voices[vs].pfreez*0.5)) hilite(hs,3) 
  if params:get("V"..vs.."_Mod")==3 then mcs(45,11,45,11,voices[vs].looplay+1) else mcs(45,11,45,11,params:get("V"..vs.."_Go")+1) end
  screen.level(5) mcs(52,11,52,11,util.clamp(params:get("V"..vs.."_Rc")+voices[vs].rc,0,1) + 1)
    hilite(hs,4) screen.move(58,13) screen.text(params:string("V"..vs.."_In")) --input
  hilite(hs,5) screen.font_size(10) screen.move(69,14) screen.text(params:string("V"..vs.."_Mod")) hilite(hs,6) --mode
  if(params:get("V"..vs.."_Mod")<3) then mcs(2,20,2,20,params:get("V"..vs.."_ALn")*0.5+0.5) end --AmplitudePoll2Length
  hilite(hs,7) if(params:get("V"..vs.."_Mod")<3) then mcs(2,25,2,25,params:get("V"..vs.."_PLn")*0.5+0.5) end --PtchPoll2Lngth
  hilite(hs,8) screen.move(5,25) screen.font_size(8) --Length/Impatienz
  if(params:get("V"..vs.."_Mod")<3) then mtmt(5,24,"Length:",40,24,params:get("V"..vs.."_Len"))
  else mtmt(5,24,"Impatienz:",50,24,params:get("V"..vs.."_Impatnz")) end hilite(hs,9) 
  if params:get("V"..vs.."_Mod")==3 then 
    mtmt(5,32,"Lp#:",27,32,params:get("V"..vs.."_LpNum")) 
  elseif params:get("V"..vs.."_Mod")==1 then 
    mcs(2,32,2,32,params:get("V"..vs.."_APs")*0.5+0.5) mtmt(5,32,"Phase:",5,32,params:get("V"..vs.."_Phase"))
  end 
  hilite(hs,10) mtmt(5,40,"FdBk:",27,40,params:get("V"..vs.."_Fbk"))
  hilite(hs,11) mcs(2,45,2,45,params:get("V"..vs.."_ASp")*0.5+0.5) mtmt(5,48,"Speed:",35,48,params:get("V"..vs.."_Spd"))
  hilite(hs,12) mtmt(65,26,"Pan:",83,26,params:get("V"..vs.."_Pn"))
  hilite(hs,13) mtmt(65,35,"Vol:",80,35,params:get("V"..vs.."_Vol"))
  hilite(hs,14) mtmt(50,44,"Btz/Cyc:",50,44,"") screen.font_size(15) screen.move(72,58) screen.font_face(8)
  screen.text(params:get("V"..vs.."_Ofst").."/"..countess.."/"..params:get("V"..vs.."_Cyc")) screen.font_face(1) screen.font_size(8)
  hilite(hs,15) screen.move(100,32) screen.text("APRc:") mcs(123,30,123,30,params:get("V"..vs.."_ARc")*0.5+0.5)
  hilite(hs,16) screen.move(100,40) screen.text("LFO:") mcs(119,38,119,38,0.5+voices[vs].plf)
end

function mcs(x,y,cx,cy,cw) screen.move(x,y) screen.circle(cx,cy,cw) screen.stroke() end
function mtmt(x,y,txt,a,b,xtx) screen.move(x,y) screen.text(txt) screen.move(a,b) screen.text(xtx) end
function hilite(sl,cmp) if sl==cmp then screen.level(15) else screen.level(5) end end
