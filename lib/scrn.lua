--screen stuff
UI = require("ui") ply = UI.PlaybackIcon.new(6,5,8,4)
function redraw()
  screen.clear() screen.aa(0) screen.move(1,1) 
  if params:get("InMon")==1 then screen.level(15) else screen.level(2) end screen.circle(2,2,0.5) screen.stroke()
  screen.level(1) screen.rect(86,1,44,15) screen.close() screen.fill() screen.stroke()
  screen.font_face(22) screen.move(88,12) screen.font_size(11) 
  if page==1 then screen.level(15) else screen.level(0) end screen.text("LO") screen.move(106,12)
  if page==2 then screen.level(15) else screen.level(0) end screen.font_size(13) screen.text("|") screen.move(111,12) 
  if page==3 then screen.level(15) else screen.level(0) end screen.font_size(11) screen.text("KI")
  screen.font_face(24) screen.font_size(7)
  if page==1 then
    hilite(sel,-9) screen.aa(1) mcs(50,59,50,59,0.5+(params:get("AT1")*0.5)) screen.aa(0)
    hilite(sel,-8) screen.aa(1) mcs(54,59,54,59,0.5+(params:get("AT2")*0.5)) screen.aa(0)
    hilite(sel,-7) mtmt(58,62,"thrsh:",81,62,params:get("ATr"))
    hilite(sel,-6) screen.aa(1) mcs(110,59,110,59,0.5+(params:get("PT1")*0.5)) screen.aa(0)
    hilite(sel,-5) screen.aa(1) mcs(118,59,118,59,0.5+(params:get("PT2")*0.5)) screen.aa(0)
    hilite(sel,-4) screen.aa(1) mcs(114,62,114,62,0.5+(params:get("S_PRz")*0.5)) screen.aa(0)
    hilite(sel,-3) screen.aa(1) mcs(124,55,124,55,0.5+(prmfreez*0.5)) hilite(sel,-2) mcs(124,59,124,59,0.5+(lrn*0.5)) screen.aa(0)
    screen.move(25,12) hilite(sel,0) screen.text("tempo: "..params:get("clock_tempo"))
    hilite(sel,1) screen.move(25,20)
    if swuiflag == 1 then screen.text("swidth: "..params:get("Swdth")) else screen.text("swing: "..params:get("Swng")) end
    hilite(sel,2) screen.move(8,30)
    if params:get("Fxv")>0 then screen.text("FxV: "..params:get("Fxvc").." ON") 
    else screen.text("FxV: "..params:get("Fxvc").." OFF") end hilite(sel,3) screen.move(8,38)
    screen.text("Dir#"..fildrsel..":") screen.move(8,46)
    screen.text(util.trim_string_to_width(string.sub(fildir[fildrsel], 21, string.match(fildir[fildrsel], "^.*()/")),50))
    hilite(sel,24) screen.move(4,60) screen.text("Pre#:"..sprenum) screen.aa(1) mcs(2,58,2,58,0.5+(spr*0.5)) hilite(sel,25) 
    screen.aa(0) screen.move(32,58) screen.text("M:"..params:get("MPre")) screen.level(5)
    for k=1,4 do
      hilite(sel,k+3) screen.move(60,(k*8)+21) screen.text(params:get("S"..k.."_Svl")) hilite(sel,k+7) screen.aa(1)
      if params:get("S"..k.."_Dfl")>0 then mcs(75,(k*8)+19,75,(k*8)+19,2) else mcs(75,(k*8)+19,75,(k*8)+19,1) end 
      screen.aa(0) hilite(sel,k+11) screen.move(80,(k*8)+21) 
      screen.text((#seq[k]+params:get("S"..k.."_Sln"))) 
      hilite(sel,k+15) screen.move(95,(k*8)+19) screen.aa(1)
      if params:get("S"..k.."_Stt")==2 then screen.circle(94,(k*8)+19,2) 
      elseif params:get("S"..k.."_Stt")==1 then screen.circle(94,(k*8)+19,1) 
      else screen.circle(94,(k*8)+19,0.2) end screen.stroke() screen.aa(0)
      hilite(sel,k+19) screen.move(100,(k*8)+21)
      if params:get("S"..k.."_Rct")>0 then screen.aa(1) screen.font_face(20) else screen.aa(0) screen.font_face(24) end --ran cutoff
      screen.text("F"..k) screen.stroke() screen.aa(0) screen.font_face(24)
    end 
  elseif page==2 then seqpg(spel)
  else if lfop>0 then lfopag(lsel,psel,vsel) else softcutv(vsel,hsel) end end ply:redraw() screen.update() rdrw=0
end

function seqpg(slct)
  screen.level(5) 
    for k=1,4 do
      if (k==((slct%4)+1)) and ((slct<4) and (slct>-1)) then
        if edit==1 then 
          screen.move(2,(k*8)+19) screen.font_size(7) screen.font_face(2) screen.text("E") screen.font_face(24) 
        else screen.font_size(7) screen.move(2,(k*8)+19) screen.text(">") end
      end screen.font_face(24)
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
  local countess=voices[vs].tixx 
  screen.level(1) screen.rect(101,34,16,7) screen.close() screen.fill() screen.stroke()
  hilite(hs,-1) screen.aa(1) mcs(11,58,11,58,(vpr*0.5)+0.5) screen.aa(0)
  screen.font_size(7) screen.move(15,60) screen.text("Preset#")
  screen.font_size(8) screen.move(44,61) screen.text(vprenum) screen.aa(1)
  hilite(hs,1) mcs(26,2,26,2,0.5) hilite(hs,2) screen.rect(21,5,9,10) screen.move(23,13) screen.text(vs) 
  mcs(35,11,35,11,0.5+(voices[vs].pfreez*0.5)) hilite(hs,3) 
  if params:get("V"..vs.."_Mod")==3 then mcs(45,11,45,11,voices[vs].looplay+1) else mcs(45,11,45,11,params:get("V"..vs.."_Go")+1) end
  screen.level(5) mcs(52,11,52,11,util.clamp(params:get("V"..vs.."_Rc")+voices[vs].rc,0,1) + 1)
  screen.font_size(7) hilite(hs,4) screen.move(58,13) screen.aa(0) screen.text(params:string("V"..vs.."_In")) --input
  hilite(hs,5) screen.font_size(8) screen.move(69,14) screen.text(params:string("V"..vs.."_Mod")) hilite(hs,6) --mode
  screen.aa(1)
  if(params:get("V"..vs.."_Mod")<3) then mcs(2,20,2,20,params:get("V"..vs.."_ALn")*0.5+0.5) --AmplitudePoll2Length
  hilite(hs,7) mcs(2,24,2,24,params:get("V"..vs.."_PLn")*0.5+0.5) end --PtchPoll2Lngth
  hilite(hs,8) screen.move(5,25) screen.font_size(7) screen.aa(0) --Length/Impatienz
  if(params:get("V"..vs.."_Mod")<3) then mtmt(5,24,"Length:",40,24,params:get("V"..vs.."_Len"))
  else mtmt(5,24,"Impatienz:",50,24,params:get("V"..vs.."_Impatnz")) end hilite(hs,9) 
  if params:get("V"..vs.."_Mod")==3 then 
    mtmt(5,32,"Lp#:",27,32,params:get("V"..vs.."_LpNum")) 
  elseif params:get("V"..vs.."_Mod")==1 then 
    screen.aa(1) mcs(2,30,2,30,params:get("V"..vs.."_APs")*0.5+0.5) screen.aa(0) mtmt(5,32,"Phase:",40,32,params:get("V"..vs.."_Phase"))
  end 
  hilite(hs,10) mtmt(5,40,"FdBk:",27,40,params:get("V"..vs.."_Fbk"))
  hilite(hs,11) screen.aa(1) mcs(2,45,2,45,params:get("V"..vs.."_ASp")*0.5+0.5) screen.aa(0) mtmt(5,48,"Speed:",35,48,params:get("V"..vs.."_Spd"))
  hilite(hs,12) mtmt(69,26,"Pan:",88,26,params:get("V"..vs.."_Pn"))
  hilite(hs,13) mtmt(69,35,"Vol:",85,35,params:get("V"..vs.."_Vol"))
  hilite(hs,14) mtmt(60,44,"Btz/Cyc:",60,44,"") screen.aa(1) screen.font_size(11) screen.move(72,58) screen.font_face(24)
  screen.text(params:get("V"..vs.."_Ofst").."/"..countess.."/"..params:get("V"..vs.."_Cyc")) screen.font_face(24) screen.font_size(7)
  hilite(hs,15) screen.move(103,32) screen.aa(0) screen.text("APRc:") screen.aa(1) mcs(125,30,125,30,params:get("V"..vs.."_ARc")*0.5+0.5)
  if hs==16 then screen.level(15) else screen.level(5) end screen.move(102,40) screen.aa(0) screen.text("LFO")
end

function lfopag(ls,ps,vs)
  screen.font_size(8) screen.level(1) screen.font_face(22)
  screen.rect(20,4,62,11) screen.close() screen.fill() screen.stroke()
  screen.move(21,12) if ls==0 then screen.level(15) else screen.level(5) end 
  screen.text("V"..vs.."_LFO&Fltr") screen.font_size(7) screen.font_face(24)
  screen.level(15) screen.move(2,23) screen.text("Pos") screen.move(18,23) screen.text("Len")
  screen.move(34,23) screen.text("Spd") screen.move(50,23) screen.text("Fbk")
  screen.move(67,23) screen.text("CF") screen.move(83,23) screen.text("Q") screen.font_size(7)
  for i=1,6 do
    screen.move((i*16)-14, 32)
    if i==1 then 
       if ls==1 and psel==1 then screen.level(15) else screen.level(8) end screen.text(params:string("V"..vs.."_PLFO"))
    elseif i==2 then 
       if ls==2 and psel==1 then screen.level(15) else screen.level(8) end screen.text(params:string("V"..vs.."_LLFO"))
    elseif i==3 then 
       if ls==3 and psel==1 then screen.level(15) else screen.level(8) end screen.text(params:string("V"..vs.."_SLFO"))
    elseif i==4 then 
       if ls==4 and psel==1 then screen.level(15) else screen.level(8) end screen.text(params:string("V"..vs.."_FLFO"))
    elseif i==5 then
       if ls==5 and psel==1 then screen.level(15) else screen.level(8) end screen.text(params:string("V"..vs.."_CLFO"))
    else if ls==6 and psel==1 then screen.level(15) else screen.level(8) end screen.text(params:string("V"..vs.."_QLFO")) end
  end
  for i=1,6 do
    screen.move((i*16)-14, (i%2)*7+40)
    if i==1 then 
       if ls==1 and psel==2 then screen.level(15) else screen.level(8) end screen.text(poslfoz[vs]:get('period'))
    elseif i==2 then 
       if ls==2 and psel==2 then screen.level(15) else screen.level(8) end screen.text(lenlfoz[vs]:get('period'))
    elseif i==3 then 
       if ls==3 and psel==2 then screen.level(15) else screen.level(8) end screen.text(spdlfoz[vs]:get('period'))
    elseif i==4 then 
       if ls==4 and psel==2 then screen.level(15) else screen.level(8) end screen.text(fbklfoz[vs]:get('period'))
    elseif i==5 then
       if ls==5 and psel==2 then screen.level(15) else screen.level(8) end screen.text(flclfoz[vs]:get('period'))
    else if ls==6 and psel==2 then screen.level(15) else screen.level(8) end screen.text(flqlfoz[vs]:get('period')) end
  end
  for i=1,6 do
    screen.move((i*16)-14, 57)
    if i==1 then 
       if ls==1 and psel==3 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_PLFMax"))
    elseif i==2 then 
       if ls==2 and psel==3 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_LLFMax"))
    elseif i==3 then 
       if ls==3 and psel==3 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_SLFMax"))
    elseif i==4 then 
       if ls==4 and psel==3 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_FLFMax"))
    elseif i==5 then
       if ls==5 and psel==3 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_CLFMax"))
    else if ls==6 and psel==3 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_QLFMax")) end
  end
  for i=1,6 do
    screen.move((i*16)-14, 64)
    if i==1 then 
       if ls==1 and psel==4 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_PLFMin"))
    elseif i==2 then 
       if ls==2 and psel==4 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_LLFMin"))
    elseif i==3 then 
       if ls==3 and psel==4 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_SLFMin"))
    elseif i==4 then 
       if ls==4 and psel==4 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_FLFMin"))
    elseif i==5 then
       if ls==5 and psel==4 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_CLFMin"))
    else if ls==6 and psel==4 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..i.."_QLFMin")) end
  end
  for i=1,7 do
    screen.move(95, i*7 + 15) screen.font_size(6)
    if i==1 then
      if ls==7 then screen.level(15) else screen.level(8) end screen.text("FDr")
    elseif i==2 then
      if ls==8 then screen.level(15) else screen.level(8) end screen.text("FLo")
    elseif i==3 then
      if ls==9 then screen.level(15) else screen.level(8) end screen.text("FHi")
    elseif i==4 then
      if ls==10 then screen.level(15) else screen.level(8) end screen.text("FBP")
    elseif i==5 then
      if ls==11 then screen.level(15) else screen.level(8) end screen.text("FBR")
    elseif i==6 then
      if ls==12 then screen.level(15) else screen.level(8) end screen.text("CF")
    elseif i==7 then
      if ls==13 then screen.level(15) else screen.level(8) end screen.text("Q")
    end
  end
  for i=1,7 do
    screen.move(108, i*7 + 15) screen.font_size(7)
    if i==1 then
      if ls==7 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_FDry"))
    elseif i==2 then
      if ls==8 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_FLoP"))
    elseif i==3 then
      if ls==9 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_FHiP"))
    elseif i==4 then
      if ls==10 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_FBnP"))
    elseif i==5 then
      if ls==11 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_FBnR"))
    elseif i==6 then
      if ls==12 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_CtOff"))
    elseif i==7 then
      if ls==13 then screen.level(15) else screen.level(8) end screen.text(params:get("V"..vs.."_BndWdt"))
    end
  end
end

function mcs(x,y,cx,cy,cw) screen.move(x,y) screen.circle(cx,cy,cw) screen.stroke() end
function mtmt(x,y,txt,a,b,xtx) screen.move(x,y) screen.text(txt) screen.move(a,b) screen.text(xtx) end
function hilite(sl,cmp) if sl==cmp then screen.level(15) else screen.level(5) end end
