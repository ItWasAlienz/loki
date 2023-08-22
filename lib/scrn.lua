--screen stuff
UI = require("ui") ply = UI.PlaybackIcon.new(69,5,8,4)
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
    hilite(sel,-9) mcs(44,59,44,59,0.5+(params:get("AT1")*0.5))
    hilite(sel,-8) mcs(48,59,48,59,0.5+(params:get("AT2")*0.5)) hilite(sel,-7) mtmt(52,62,"thrsh:",77,62,params:get("ATr"))
    hilite(sel,-6) mcs(112,59,112,59,0.5+(params:get("PT1")*0.5))
    hilite(sel,-5) mcs(120,59,120,59,0.5+(params:get("PT2")*0.5))
    hilite(sel,-4) mcs(116,62,116,62,0.5+(params:get("S_PRz")*0.5)) 
    hilite(sel,-3) mcs(126,59,126,59,0.5+(prmfreez*0.5)) hilite(sel,-2) mcs(126,62,126,62,0.5+(lrn*0.5)) 
    screen.move(4,10) hilite(sel,0) screen.text("tempo: "..params:get("clock_tempo"))
    hilite(sel,1) screen.move(4,18)
    if swuiflag == 1 then screen.text("swidth: "..params:get("Swdth")) else screen.text("swing: "..params:get("Swng")) end
    hilite(sel,2) screen.move(8,26)
    if params:get("Fxv")>0 then screen.text("fxv: "..params:get("Fxvc").." ON") 
    else screen.text("fxv: "..params:get("Fxvc").." OFF") end hilite(sel,3) screen.move(8,34)
    screen.text("Dir#"..fildrsel..":") screen.move(8,42)
    screen.text(util.trim_string_to_width(string.sub(fildir[fildrsel], 21, string.match(fildir[fildrsel], "^.*()/")),50))
    hilite(sel,24) screen.move(4,60) screen.text("Pre#:"..sprenum) mcs(2,58,2,58,0.5+(spr*0.5)) hilite(sel,25) 
    screen.move(32,53) screen.text("M:"..params:get("MPre")) screen.level(5)
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
    screen.move(8,11) hilite(slct,5) screen.text("Dir#"..fildrsel..":") screen.move(8,19)
    screen.text(string.sub(fildir[fildrsel], 21, string.match(fildir[fildrsel], "^.*()/")))
end

function softcutv(vs,hs)
  local countess=voices[vs].tixx+1 hilite(hs,-1) mcs(33,60,33,60,(vpr*0.5)+0.5)
  screen.font_size(6) screen.move(35,62) screen.text("Preset#")
  screen.font_size(10) screen.move(62,63) screen.text(vprenum) screen.font_size(8)
  hilite(hs,1) mcs(2,8,2,8,0.5) hilite(hs,2) screen.rect(8,3,8,9) screen.move(10,10) 
  screen.text(vs) mcs(20,8,20,8,0.5+(voices[vs].pfreez*0.5)) hilite(hs,3) 
  if params:get("V"..vs.."_Mod")==3 then mcs(26,8,26,8,voices[vs].looplay+1) else mcs(26,8,26,8,params:get("V"..vs.."_Go")+1) end
  screen.level(5) mcs(33,8,33,8,util.clamp(params:get("V"..vs.."_Rc")+voices[vs].rc,0,1) + 1)
  hilite(hs,4) screen.move(38,10) screen.text(params:string("V"..vs.."_In")) --input
  hilite(hs,5) screen.font_size(10) screen.move(50,11) screen.text(params:string("V"..vs.."_Mod")) hilite(hs,6) --mode
  if(params:get("V"..vs.."_Mod")<3) then mcs(2,15,2,15,params:get("V"..vs.."_ALn")*0.5+0.5) end --AmplitudePoll2Length
  hilite(hs,7) if(params:get("V"..vs.."_Mod")<3) then mcs(2,20,2,20,params:get("V"..vs.."_PLn")*0.5+0.5) end --PtchPoll2Lngth
  hilite(hs,8) screen.move(5,20) screen.font_size(8) --Length/Impatienz
  if(params:get("V"..vs.."_Mod")<3) then mtmt(5,20,"Length:",40,20,params:get("V"..vs.."_Len"))
  else mtmt(5,20,"Impatienz:",50,20,params:get("V"..vs.."_Impatnz")) end hilite(hs,9) 
  if params:get("V"..vs.."_Mod")==3 then 
    mtmt(65,26,"Lp#:",83,26,params:get("V"..vs.."_LpNum")) 
  elseif params:get("V"..vs.."_Mod")==1 then 
    mcs(60,23,60,23,params:get("V"..vs.."_APs")*0.5+0.5) mtmt(65,25,"Phase:",92,25,params:get("V"..vs.."_Phase"))
  end 
  hilite(hs,10) mtmt(88,33,"FdBk:",111,33,params:get("V"..vs.."_Fbk"))
  hilite(hs,11) mcs(2,28,2,28,params:get("V"..vs.."_ASp")*0.5+0.5) mtmt(5,30,"Speed:",35,30,params:get("V"..vs.."_Spd"))
  hilite(hs,12) mtmt(65,40,"Pan:",83,40,params:get("V"..vs.."_Pn"))
  hilite(hs,13) mtmt(5,40,"Vol:",35,40,params:get("V"..vs.."_Vol"))
  hilite(hs,14) mtmt(50,46,"Bz/Br:",50,46,"") screen.font_size(20) screen.move(72,60) screen.font_face(8)
  screen.text(countess.."/"..params:get("V"..vs.."_Bar")) screen.font_face(1) screen.font_size(8)
  hilite(hs,15) screen.move(5,50) screen.text("APRc:") mcs(28,48,28,48,params:get("V"..vs.."_ARc")*0.5+0.5)
  hilite(hs,16) screen.move(5,60) screen.text("LFO:") mcs(24,58,24,58,0.5+voices[vs].plf)
end

function mcs(x,y,cx,cy,cw) screen.move(x,y) screen.circle(cx,cy,cw) screen.stroke() end
function mtmt(x,y,txt,a,b,xtx) screen.move(x,y) screen.text(txt) screen.move(a,b) screen.text(xtx) end
function hilite(sl,cmp) if sl==cmp then screen.level(15) else screen.level(5) end end
