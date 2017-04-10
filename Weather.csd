<Cabbage> ;some comment to save changes
form caption("Weather") size(600, 350), 
button  bounds(8, 8, 70, 30), text("Thunder"), latched(0), fontcolour:0(100,100,100), channel("Thunder")
rslider bounds(8, 40, 80, 80), channel("ThunderLev"), text("Thunder Level"), range(0, 1, .5, 1, .01)
rslider bounds(8, 128, 80, 80), channel("ThunderDur"), text("Duration"), range(4, 25, 20)
rslider bounds(8, 224, 80, 80), channel("ThunderDist"), text("Distance"), range(0, 1, 0.1)
rslider bounds(104, 40, 80, 80), channel("RainLev"), text("Level"), range(0, 1, .5, 1, .01)
rslider bounds(104, 128, 80, 80), channel("RainMix"), text("Mix"), range(0, 1, .25)
rslider bounds(104, 224, 80, 80), channel("RainDens"), text("Density"), range(0, 1, .03)
rslider bounds(360, 192, 100, 100), channel("gain"), range(0, 1, .03, 1, .01), text("Wind Level"), trackercolour("lime"), outlinecolour(0, 0, 0, 50), textcolour("black")
rslider bounds(208, 40, 60, 69), channel("band1"), range(.1, 4, .5), text("Freq 1 ")
rslider bounds(272, 40, 60, 69), channel("band2"), range(.1, 4, .2), text("Freq 2")
rslider bounds(336, 40, 60, 69), channel("band3"), range(.1, 4, .4), text("Freq 3")
rslider bounds(400, 40, 60, 69), channel("band4"), range(.1, 4, .3), text("Freq 4")
rslider bounds(208, 112, 60, 69), channel("amp1"), range(0, 1, 1), text("Amp 1")
rslider bounds(272, 112, 60, 69), channel("amp2"), range(0, 1, .6), text("Amp 2")
rslider bounds(336, 112, 60, 69), channel("amp3"), range(0, 1, .15), text("Amp 3")
rslider bounds(400, 112, 60, 69), channel("amp4"), range(0, 1, .1), text("Amp 4")

rslider bounds(32, 40, 75, 65), channel("shellFreqUpper"), range(0, 20000, 10000), text("Sweep 1")
rslider bounds(112, 40, 75, 65), channel("shellFreqLower"), range(0, 5000, 100), text("Sweep 2")
rslider bounds(192, 40, 75, 65), channel("fireRate"), range(0, 20, 10), text("Fire Rate")
rslider bounds(112, 112, 75, 65), channel("reverbLevel"), range(0, 1, .3), text("LF Reverb")
rslider bounds(32, 112, 75, 65), channel("noiseLevel"), range(0, 1, .200), text("Noise Level")
rslider bounds(192, 112, 75, 65), channel("noiseFilter"), range(0, 1, 0), text("Noise Beta")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>
<CsInstruments>
; Initialize the global variables. 

; sr      =  48000
; kr      =  1500
; ksmps   =  32

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1
seed 0

gkBullX init 0
gkBullY init 0
gkBullZ init 0

/* room parameters */

idep    =  3    /* early reflection depth       */

gitmp1    ftgen   1, 0, 64, -2,                                           \
		/* depth1, depth2, max delay, IR length, idist, seed */ \
		idep, 48, -1, 0.01, 0.25, 123,                          \ 	;3
		0, 21.982, 0.05, 0.87, 4000.0, 0.6, 0.7, 0, /* ceil  */ \ 	;9
		0,  1.753, 0.05, 0.87, 3500.0, 0.5, 0.7, 0, /* floor */ \	;13
		0, 15.220, 0.05, 0.87, 5000.0, 0.8, 0.7, 0, /* front */ \	;25
		0,  9.317, 0.05, 0.87, 5000.0, 0.8, 0.7, 0, /* back  */ \	;33
		0, 17.545, 0.05, 0.87, 5000.0, 0.8, 0.7, 0, /* right */ \	;41
		0, 12.156, 0.05, 0.87, 5000.0, 0.8, 0.7, 0  /* left  */ 	;49

gitmp2    ftgen   2, 0, 64, -2,                                           \
		/* depth1, depth2, max delay, IR length, idist, seed */ \
		idep, 48, -1, 0.01, 0.25, 123,                          \ 	;3
		1, 0, 0.05, 0.87, 4000.0, 0.6, 0.7, 2, /* ceil  */ \ 	;9
		1,  0, 0.05, 0.87, 3500.0, 0.5, 0.7, 2, /* floor */ \	;13
		1, 0, 0.05, 0.87, 5000.0, 0.8, 0.7, 2, /* front */ \	;25
		1,  0, 0.05, 0.87, 5000.0, 0.8, 0.7, 2, /* back  */ \	;33
		1, 0, 0.05, 0.87, 5000.0, 0.8, 0.7, 2, /* right */ \	;41
		1, 0, 0.05, 0.87, 5000.0, 0.8, 0.7, 2  /* left  */ 	;49

instr	1
 event_i "i", 2, 0, -1
 event_i "i", 4, 0, -1

 kThunder		chnget	"Thunder"	; on/off
 kThunderDur	chnget	"ThunderDur"	; on/off
 kThunderDist	scale	chnget:k("ThunderDist"),1,1.7
 if changed(kThunder)==1 then
  event	"i",3,0,kThunderDur,kThunderDist
  event	"i",3,0,kThunderDur,kThunderDist

 endif 
 endin

 instr 12
 ;Sstep		chnget  "StepsIndex"
 kStep		chnget	"Steps"	; on/off
 kStepDur	chnget	"StepsDur"	; on/off
 kStepMath	scale	chnget:k("StepsMath"),1,1.7

 if changed(kStep)==1 then
  event	"i","STEPS",0,kStepDur,kStepMath
  event "i", 799, 0,-1
 endif
 	kspat active "STEPS"
 	if (kspat > 0) then
 	event_i "i", 799, 0, -1
  endif
 ;   if changed(kStep)==0 then
 ;  event "i", 799, 0,0.5
 ; endif
endin

instr 13
 Schan		chnget  "ShotsIndex"
 kShot		chnget	"Shots"	; on/off
 kShotDur	chnget	"ShotsDur"	; on/off
 kShotDist	scale	chnget:k("ShotsDist"),1,1.7

 if changed(kShot)==1 then
 kComp0       strcmpk     "ShotsChan0", Schan
  kComp1       strcmpk     "ShotsChan1", Schan
  kComp2       strcmpk     "ShotsChan2", Schan
  kComp3       strcmpk     "ShotsChan3", Schan
  kComp4       strcmpk     "ShotsChan4", Schan
  kComp5       strcmpk     "ShotsChan5", Schan
  kComp6       strcmpk     "ShotsChan6", Schan
  kComp7       strcmpk     "ShotsChan7", Schan
  event	"i","SHOTS",0,10
  if kComp0 == 0 then
  event "i", 800, 0,10
  endif
  if kComp1 == 0 then
  event "i", 801, 0,10
  endif
  if kComp2 == 0 then
  event "i", 802, 0,10
  endif
  if kComp3 == 0 then
  event "i", 803, 0,10
  endif
  if kComp4 == 0 then
  event "i", 804, 0,10
  endif
  if kComp5 == 0 then
  event "i", 805, 0,10
  endif
  if kComp6 == 0 then
  event "i", 806, 0,10
  endif
  if kComp7 == 0 then
  event "i", 807, 0,10
  endif
 endif 
endin

instr 14
 Schan		chnget  "BulletsIndex"
 kBullet		chnget	"Bullets"	; on/off
 kBulletDur	chnget	"BulletsDur"	; on/off
 kBulletDist	scale	chnget:k("BulletsDist"),1,1.7

 if changed(kBullet)==1 then
 kComp0       strcmpk     "BulletsChan0", Schan
  kComp1       strcmpk     "BulletsChan1", Schan
  kComp2       strcmpk     "BulletsChan2", Schan
  ; kComp3       strcmpk     "BulletsChan3", Schan
  ; kComp4       strcmpk     "BulletsChan4", Schan
  ; kComp5       strcmpk     "BulletsChan5", Schan
  ; kComp6       strcmpk     "BulletsChan6", Schan
  ; kComp7       strcmpk     "BulletsChan7", Schan
  event	"i","BULLETS",0,10
  if kComp0 == 0 then
  event "i", 900, 0,-1
  endif
  kspat active "BULLETS"
 	if (kspat > 0) then
 	event_i "i", 900, 0, -1
  endif
  ; if kComp1 == 0 then
  ; event "i", 901, 0,10
  ; endif
  ; if kComp2 == 0 then
  ; event "i", 902, 0,10
  ; endif
  ; if kComp3 == 0 then
  ; event "i", 903, 0,10
  ; endif
  ; if kComp4 == 0 then
  ; event "i", 904, 0,10
  ; endif
  ; if kComp5 == 0 then
  ; event "i", 905, 0,10
  ; endif
  ; if kComp6 == 0 then
  ; event "i", 906, 0,10
  ; endif
  ; if kComp7 == 0 then
  ; event "i", 907, 0,10
  ; endif
 endif 
endin

instr 2
kGain chnget "gain"

aNoise pinker

kPan1 jitter .5, .1, 1 
kPan1 = kPan1+.5
kPan2 jitter .5, .1, 1 
kPan2 = kPan2+.5
kPan3 jitter .5, .1, 1
kPan3 = kPan3+.5 
kPan4 jitter .5, .1, 1
kPan4 = kPan4+.5 
 
kLowFreqWindSpeed = 100+randi:k(50, chnget:k("band1"), 1)
chnset kLowFreqWindSpeed, "lowFreqWindSpeed"
aLow butterlp aNoise, kLowFreqWindSpeed
aMid1 butterbp aNoise, 200+randi:k(100, chnget:k("band2"), 1), 100
aMid2 butterbp aNoise, 800+randi:k(300, chnget:k("band3"), 1), 400
aHigh butterbp aNoise, 2000+randi:k(500, chnget:k("band4"), 1), chnget:k ("bw1")

aLowL, aLowR pan2 aLow*chnget:k("amp1"), random(0, 1) 
aMid1L, aMid1R pan2 aMid1*chnget:k("amp2"), random(0, 1) 
aMid2L, aMid2R pan2 aMid2*chnget:k("amp3"), random(0, 1) 
aHighL, aHighR pan2 aHigh*chnget:k("amp4"), random(0, 1) 

aLeft = aLowL+aMid1L+aMid2L+aHighL
aLeft comb aLeft, 2, .5

aRight = aLowR+aMid1R+aMid2R+aHighR
aRight comb aRight, 2, .33

if chnget:k ("muteReverb") == 1  then
aLeft, aRight reverbsc aLeft, aRight, chnget:k("reverbSize") , chnget:k("reverbFCO")
endif

outs aLeft*kGain, aRight*kGain

endin

instr		3	; thunder
 kenv		expseg	0.01, 0.05, 1, 0.1, 0.5, p3-0.01, 0.01
 aNse		pinkish	kenv*0.6
 kCF		expon		p4,p3,0.03
 kCFoct		randomh	2*kCF,6*kCF, expon:k(50, p3, 20)
 aNse		reson		aNse*3,a(cpsoct(kCFoct)),a(cpsoct(kCFoct)*5),1
 aNse		butlp		aNse, 1000
 ipan		random	0,1
 aL,aR	pan2		aNse,ipan
 		outs		aL, aR
		chnmix	aL*0.15, "SendL"						; also send to the reverb
 		chnmix	aR*0.15, "SendR" 		
endin

instr		STEPS	; step
 Sstep		chnget  "StepsIndex"

 kenv		expseg 1, p3-3.5, 0.01
 aNse		pinkish	kenv*0.5
 kCF		expon		p4,p3,0.001
 kCFoct		randomh	2*kCF,6*kCF, expon:k(100, p3, 50)
 aNse		reson		aNse,a(cpsoct(kCFoct)*5),a(cpsoct(kCFoct)*5),1
 aNse		butterhp		aNse, 100
 aNse		butlp		aNse, 3000
 ;ipan		random	0,1
 ;aL,aR	pan2		aNse,ipan
 		;aL,aR	pan2		aNse, .5
 		;outs		aL, aR

	kRoomFwd	chnget	"FwdDist"
	kRoomBwd	chnget	"BwdDist"
	kRoomLft	chnget	"LftDist"
	kRoomRgt	chnget	"RgtDist"
	kRoomUp	chnget	"UpDist"
	kRoomDwn	chnget	"DwnDist"

	kFreqFwd	chnget	"FwdFreq"
	kFreqBwd	chnget	"BwdFreq"
	kFreqLft	chnget	"LftFreq"
	kFreqRgt	chnget	"RgtFreq"
	kFreqUp	chnget	"UpFreq"
	kFreqDwn	chnget	"DwnFreq"

	kLevelFwd	chnget	"FwdLevel"
	kLevelBwd	chnget	"BwdLevel"
	kLevelLft	chnget	"LftLevel"
	kLevelRgt	chnget	"RgtLevel"
	kLevelUp	chnget	"UpLevel"
	kLevelDwn	chnget	"DwnLevel"

	ioffset init -3
	kison 	init 0

	if kRoomFwd == 100 then
	kison = 0
	tablew  kison, 26+ioffset-1, gitmp1
	else
	kison = 1
	tablew  kison, 26+ioffset-1, gitmp1
	tablew  kRoomFwd, 26+ioffset, gitmp1
	tablew  kFreqFwd, 26+ioffset+3, gitmp1
	tablew  kLevelFwd, 26+ioffset+2, gitmp1
	endif
	if kRoomBwd == 100 then
	kison = 0
	tablew  kison, 34+ioffset-1, gitmp1
	else
	kison = 1
	tablew  kison, 34+ioffset-1, gitmp1
	tablew  kRoomBwd, 34+ioffset, gitmp1
	tablew  kFreqBwd, 34+ioffset+3, gitmp1
	tablew  kLevelBwd, 34+ioffset+2, gitmp1
	endif
	if kRoomLft == 100 then
	kison = 0
	tablew  kison, 50+ioffset-1, gitmp1
	else
	kison = 1
	tablew  kison, 50+ioffset-1, gitmp1
	tablew  kRoomLft, 50+ioffset, gitmp1
	tablew  kFreqLft, 50+ioffset+3, gitmp1
	tablew  kLevelLft, 50+ioffset+2, gitmp1
	endif
	if kRoomRgt == 100 then
	kison = 0
	tablew  kison, 42+ioffset-1, gitmp1
	else
	kison = 1
	tablew  kison, 42+ioffset-1, gitmp1
	tablew  kRoomRgt, 42+ioffset, gitmp1
	tablew  kFreqRgt, 42+ioffset+3, gitmp1
	tablew  kLevelRgt, 42+ioffset+2, gitmp1
	endif
	if kRoomUp == 100 then
	kison = 0
	tablew  kison, 10+ioffset-1, gitmp1
	else
	kison = 1
	tablew  kison, 10+ioffset-1, gitmp1
	tablew  kRoomUp, 10+ioffset, gitmp1
	tablew  kFreqUp, 10+ioffset+3, gitmp1
	tablew  kLevelUp, 10+ioffset+2, gitmp1
	endif
	if kRoomDwn == 100 then
	kison = 0
	tablew  kison, 18+ioffset-1, gitmp1
	else
	kison = 1
	tablew  kison, 18+ioffset-1, gitmp1
	tablew  kRoomDwn, 18+ioffset, gitmp1
	tablew  kFreqDwn, 18+ioffset+3, gitmp1
	tablew  kLevelDwn, 18+ioffset+2, gitmp1
	endif
	
		chnmix	aNse*4, Sstep						; also send to the reverb	
endin

instr		SHOTS	; Shot
  Sstep		chnget  "ShotsIndex"
 ; kenv		expseg 1, p3-3.5, 0.01
 ; aNse		pinkish	kenv*0.5
 ; kCF		expon		p4,p3,0.001
 ; kCFoct		randomh	2*kCF,6*kCF, expon:k(100, p3, 50)
 ; aNse		reson		aNse,a(cpsoct(kCFoct)*5),a(cpsoct(kCFoct)*5),1
 ; aNse		butterbp		aNse, 500, 1000

	; 	chnmix	aNse, Sstep						; also send to the reverb

	iDur1 = 0.020
	k1 line chnget:i("shellFreqUpper"), iDur1, 100
	aShellBurst oscil .25, k1
	kEnv1 linseg 1, iDur1, 1, 0, 0, 1, 0
	aShellBurst = aShellBurst*kEnv1

	iDur2 = 0.030
	k1 line chnget:i("shellFreqLower"), iDur2, 100
	aExitBurst oscil .25, k1
	kEnv2 linseg 1, iDur2, 1, 0, 0, 1, 0
	aExitBurst = aExitBurst*kEnv2

	iDur3 chnget "noiseLevel"
	aEnv expon .4, iDur3, 0.0001
	aEnv2 expon 1, 10*chnget:i("reverbLevel"), 0.0001
	aNoiseBurst noise 1, chnget:i("noiseFilter")	
	aLowpass butterlp aNoiseBurst, 300
	aLowNoise = aLowpass*aEnv2
	
	aNoiseBurst = aNoiseBurst*aEnv
	
	;outs aNoiseBurst+aLowNoise, aNoiseBurst+aLowNoise
	chnmix aNoiseBurst+aLowNoise, Sstep
	aBurstMix = aShellBurst+aExitBurst	
	;outs aBurstMix, aBurstMix
	chnmix	aBurstMix, Sstep

	a1 reson aNoiseBurst, 300+rnd31:i(200, 1, 1), 200
	a2 reson aNoiseBurst, 500+rnd31:i(200, 1, 1), 400
	a3 reson aNoiseBurst, 700+rnd31:i(200, 1, 1), 600
	a4 reson aNoiseBurst, 900+rnd31:i(200, 1, 1), 800

	a5 reson aNoiseBurst, 2200+rnd31:i(1000, 1, 1), 2200
	a6 reson aNoiseBurst, 2400+rnd31:i(1000, 1, 1), 2400
	a7 reson aNoiseBurst, 2600+rnd31:i(1000, 1, 1), 2600
	a8 reson aNoiseBurst, 2800+rnd31:i(1000, 1, 1), 2800
	
	aResonanceMix = (a1+a2+a3+a4+a5+a6+a7+a8)
	aBalance balance aResonanceMix, aNoiseBurst
	;outs aBalance, aBalance

	chnmix	aBalance, Sstep						; also send to the reverb

endin

; instr DEBUG

; chnset gkBullX, "DebugX"

; chnset gkBullY, "DebugY"

; chnset gkBullZ, "DebugZ"

; endin

instr BULLETS
Schan		chnget  "BulletsIndex"
kMod linseg 200, 200, 500
kAmp1 linseg 0,0.1,1,4,0
kAmp2 linseg 0,3,1,2,0
;Классическая операторная пара.
aMod oscil 1, 270			;Modulator
aCar1 oscil kAmp1, 500 + aMod*kMod  ;Carrier - несущая
aCar2 oscil kAmp2, 450 + aMod*aCar1*kMod*0.5  ;Carrier - несущая
;aMix = aCar1 + aCar2
;outs aCar2*0.2,aCar2*0.2
chnmix	aCar2*0.2, Schan

endin

instr 555
	kMod linseg 200, p3, 500
kAmp1 linseg 1,0.1,0.5,0.5,0
kAmp2 linseg 1,0.5,0.5,0.5,0
;Классическая операторная пара.
aMod oscil 1, 300			;Modulator
aCar1 oscil kAmp1, 600 + aMod*kMod  ;Carrier - несущая
aCar2 oscil kAmp2, 300 + aMod*aCar1*kMod*0.5  ;Carrier - несущая
;aMix = aCar1 + aCar2
;outs aCar1*0.1,aCar2*0.1
		chnmix	aCar1*0.1, "SurSendL"						; also send to the reverb
 		chnmix	aCar2*0.1, "SurSendR" 		
endin

instr		4	; rain
 kRainMix	chnget	"RainMix"
 kRainDens	chnget	"RainDens"
 
 kTrig	dust		1, 1000*kRainDens
 kenv		linsegr	0,2,1,5,0
 		schedkwhen	kTrig, 0, 0, 5, 0, 0.008, kenv*(1-sqrt(kRainMix))
 aNse	dust2		0.1*kenv*sqrt(kRainMix),3000*kRainDens
 aNse2	dust2		0.1*kenv*sqrt(kRainMix),1500*kRainDens
 aNse	butlp		aNse, 1000
 aNse2	butlp		aNse2, 1000
 		outs		aNse,aNse2
endin

instr		5	; rain
 iCPS1		random	10,11
 iCPS2		random	13,14
 idB		random	-10,-32
 aCPS		expon		cpsoct(iCPS1),p3,cpsoct(iCPS2)
 aEnv		expon		1,p3,0.001
 aSig		poscil	aEnv*ampdbfs(idB)*p4,aCPS
 aSig		buthp		aSig,9000
 ipan		random	0,1
 aL,aR	pan2		aSig,ipan
 		outs		aL, aR
		chnmix	aL*0.3, "SendL"						; also send to the reverb
 		chnmix	aR*0.3, "SendR" 		
endin



instr		999	; reverb
 aInL		chnget	"SendL"
 aInR		chnget	"SendR"
 aL, aR	reverbsc	aInL, aInR, 0.9, 12000
 		outs		aL, aR
 		chnclear	"SendL"
 		chnclear	"SendR"
endin

instr 900

 aRetIn		chnget	"BulletsChan0"

gkBullX       chnget	"BulletsX0"
gkBullY       chnget	"BulletsY0"
gkBullZ       chnget	"BulletsZ0"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, gkBullX, gkBullY, gkBullZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */

;convert to UHJ format (stereo)
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre

	outs aL, aR

	chnclear	"BulletsChan0"

	endin

instr 901

 aRetIn		chnget	"BulletsChan1"

kSndX       chnget	"BulletsX1"
kSndY       chnget	"BulletsY1"
kSndZ       chnget	"BulletsZ1"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
; aL     =  aW + aY              /* left                 */
; aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"BulletsChan1"

	endin

instr 799

; 	 ioffset init -3

;   ival tab_i 26+ioffset-1, gitmp1
; chnset ival, "Answer1"
; ival tab_i 34+ioffset-1, gitmp1
; chnset ival, "Answer2"
; ival tab_i 50+ioffset-1, gitmp1
; chnset ival, "Answer3"
; ival tab_i 42+ioffset-1, gitmp1
; chnset ival, "Answer4"
; ival tab_i 10+ioffset-1, gitmp1
; chnset ival, "Answer5"
; ival tab_i 18+ioffset-1, gitmp1
; chnset ival, "Answer6"

;   ival tab_i 26+ioffset, gitmp1
; chnset ival, "Answer1"
; ival tab_i 34+ioffset, gitmp1
; chnset ival, "Answer2"
; ival tab_i 50+ioffset, gitmp1
; chnset ival, "Answer3"
; ival tab_i 42+ioffset, gitmp1
; chnset ival, "Answer4"
; ival tab_i 10+ioffset, gitmp1
; chnset ival, "Answer5"
; ival tab_i 18+ioffset, gitmp1
; chnset ival, "Answer6"


aRetIn		chnget	"StepsChan0"

kSndX       chnget	"StepsX0"
kSndY       chnget	"StepsY0"
kSndZ       chnget	"StepsZ0"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
; aL     =  aW + aY              /* left                 */
; aR     =  aW - aY              /* right                */

aL, aR bformdec1 1, aW, aX, aY, aZ

; aWre, aWim	hilbert aW
; aXre, aXim	hilbert aX
; aYre, aYim	hilbert aY

; aWXre	=  0.0928*aXre + 0.4699*aWre
; aWXim	=  0.2550*aXim - 0.1710*aWim

; aL	=  aWXre + aWXim + 0.3277*aYre
; aR	=  aWXre - aWXim - 0.3277*aYre

	outs aL, aR

	chnclear	"StepsChan0"
	;turnoff
	endin

instr 800

 aRetIn		chnget	"ShotsChan0"

kSndX       chnget	"ShotsX0"
kSndY       chnget	"ShotsY0"
kSndZ       chnget	"ShotsZ0"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */

aL, aR bformdec1 1, aW, aX, aY, aZ

;convert to UHJ format (stereo)
; aWre, aWim	hilbert aW
; aXre, aXim	hilbert aX
; aYre, aYim	hilbert aY

; aWXre	=  0.0928*aXre + 0.4699*aWre
; aWXim	=  0.2550*aXim - 0.1710*aWim

; aL	=  aWXre + aWXim + 0.3277*aYre
; aR	=  aWXre - aWXim - 0.3277*aYre

	outs aL, aR

	chnclear	"ShotsChan0"

	endin

instr 801

 aRetIn		chnget	"ShotsChan1"

kSndX       chnget	"ShotsX1"
kSndY       chnget	"ShotsY1"
kSndZ       chnget	"ShotsZ1"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */

aL, aR bformdec1 1, aW, aX, aY, aZ

; aWre, aWim	hilbert aW
; aXre, aXim	hilbert aX
; aYre, aYim	hilbert aY

; aWXre	=  0.0928*aXre + 0.4699*aWre
; aWXim	=  0.2550*aXim - 0.1710*aWim

; aL	=  aWXre + aWXim + 0.3277*aYre
; aR	=  aWXre - aWXim - 0.3277*aYre

	outs aL, aR

	chnclear	"ShotsChan1"

	endin

instr 802

 aRetIn		chnget	"ShotsChan2"

kSndX       chnget	"ShotsX2"
kSndY       chnget	"ShotsY2"
kSndZ       chnget	"ShotsZ2"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */

aL, aR bformdec1 1, aW, aX, aY, aZ

; aWre, aWim	hilbert aW
; aXre, aXim	hilbert aX
; aYre, aYim	hilbert aY

; aWXre	=  0.0928*aXre + 0.4699*aWre
; aWXim	=  0.2550*aXim - 0.1710*aWim

; aL	=  aWXre + aWXim + 0.3277*aYre
; aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan2"

	endin

instr 803

 aRetIn		chnget	"ShotsChan3"

kSndX       chnget	"ShotsX3"
kSndY       chnget	"ShotsY3"
kSndZ       chnget	"ShotsZ3"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */

aL, aR bformdec1 1, aW, aX, aY, aZ

; aWre, aWim	hilbert aW
; aXre, aXim	hilbert aX
; aYre, aYim	hilbert aY

; aWXre	=  0.0928*aXre + 0.4699*aWre
; aWXim	=  0.2550*aXim - 0.1710*aWim

; aL	=  aWXre + aWXim + 0.3277*aYre
; aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan3"

	endin

instr 804

 aRetIn		chnget	"ShotsChan4"

kSndX       chnget	"ShotsX4"
kSndY       chnget	"ShotsY4"
kSndZ       chnget	"ShotsZ4"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */

aL, aR bformdec1 1, aW, aX, aY, aZ

; aWre, aWim	hilbert aW
; aXre, aXim	hilbert aX
; aYre, aYim	hilbert aY

; aWXre	=  0.0928*aXre + 0.4699*aWre
; aWXim	=  0.2550*aXim - 0.1710*aWim

; aL	=  aWXre + aWXim + 0.3277*aYre
; aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan4"

	endin

instr 805

 aRetIn		chnget	"ShotsChan5"

kSndX       chnget	"ShotsX5"
kSndY       chnget	"ShotsY5"
kSndZ       chnget	"ShotsZ5"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan5"

	endin

instr 806

 aRetIn		chnget	"ShotsChan6"

kSndX       chnget	"ShotsX6"
kSndY       chnget	"ShotsY6"
kSndZ       chnget	"ShotsZ6"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan6"

	endin

instr 807

 aRetIn		chnget	"ShotsChan7"

kSndX       chnget	"ShotsX7"
kSndY       chnget	"ShotsY7"
kSndZ       chnget	"ShotsZ7"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan7"

	endin

instr 808

 aRetIn		chnget	"ShotsChan8"

kSndX       chnget	"ShotsX8"
kSndY       chnget	"ShotsY8"
kSndZ       chnget	"ShotsZ8"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan8"

	endin

instr 809

 aRetIn		chnget	"ShotsChan9"

kSndX       chnget	"ShotsX9"
kSndY       chnget	"ShotsY9"
kSndZ       chnget	"ShotsZ9"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan9"

	endin

instr 810

 aRetIn		chnget	"ShotsChan10"

kSndX       chnget	"ShotsX10"
kSndY       chnget	"ShotsY10"
kSndZ       chnget	"ShotsZ10"

aRetIn      =  aRetIn + 0.000001 * 0.000001     ; avoid underflows

imode   =  1    ; change this to 3 for 8 spk in a cube,
				; or 1 for simple stereo
idist	=  1
iovr	=  2

aW, aX, aY, aZ  spat3d aRetIn, kSndX, kSndY, kSndZ, idist, 1, imode, 2, iovr

aW      =  aW * 1.4142

; stereo
;aL     =  aW + aY              /* left                 */
;aR     =  aW - aY              /* right                */
aWre, aWim	hilbert aW
aXre, aXim	hilbert aX
aYre, aYim	hilbert aY

aWXre	=  0.0928*aXre + 0.4699*aWre
aWXim	=  0.2550*aXim - 0.1710*aWim

aL	=  aWXre + aWXim + 0.3277*aYre
aR	=  aWXre - aWXim - 0.3277*aYre
	outs aL, aR

	chnclear	"ShotsChan10"

	endin
</CsInstruments>
<CsScore> 
i1 0 [60*60*24*7] 
i12 0 [60*60*24*7] 
i13 0 [60*60*24*7] 
;i14 0 [60*60*24*7]
i999 0 [60*60*24*7]
;i222 0 [60*60*24*7]
;i 799 0 [60*60*24*7]
;i 900 0 [60*60*24*7]
 ;i 800 0 [60*60*24*7]
 ; i 801 0 [60*60*24*7]
 ; i 802 0 [60*60*24*7]
 ;i 803 0 [60*60*24*7]
; i 804 0 [60*60*24*7]
; i 805 0 [60*60*24*7]
; i 806 0 [60*60*24*7]
; i 807 0 [60*60*24*7]
; i 808 0 [60*60*24*7]
; i 809 0 [60*60*24*7]
; i 810 0 [60*60*24*7]
;e
</CsScore>
</CsoundSynthesizer>